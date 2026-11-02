"""Regression checks for restoring a model's best validation checkpoint."""

import unittest
from unittest.mock import patch

import numpy as np

from cs682.solver import Solver


class CounterModel:
    def __init__(self, with_batchnorm=False):
        self.params = {'W': np.zeros(1)}
        if with_batchnorm:
            self.bn_params = [{
                'running_mean': np.zeros(1),
                'running_var': np.zeros(1),
            }]

    def loss(self, X, y=None):
        if hasattr(self, 'bn_params'):
            self.bn_params[0]['running_mean'] += 1
            self.bn_params[0]['running_var'] += 2
        return 0.0, {'W': np.ones(1)}


class SolverCheckpointTest(unittest.TestCase):
    def run_two_updates(self, model):
        data = {
            'X_train': np.zeros((2, 1)), 'y_train': np.zeros(2, dtype=int),
            'X_val': np.zeros((1, 1)), 'y_val': np.zeros(1, dtype=int),
        }
        solver = Solver(model, data, batch_size=1, num_epochs=1,
                        optim_config={'learning_rate': 1.0}, verbose=False)
        # The first update is better on validation than the final update.
        with patch.object(solver, 'check_accuracy', side_effect=[0.5, 0.8, 0.5, 0.6]):
            solver.train()
        return solver

    def test_restores_batchnorm_statistics_from_the_selected_epoch(self):
        model = CounterModel(with_batchnorm=True)
        solver = self.run_two_updates(model)
        self.assertEqual(solver.best_val_acc, 0.8)
        np.testing.assert_array_equal(model.params['W'], [-1.0])
        np.testing.assert_array_equal(model.bn_params[0]['running_mean'], [1.0])
        np.testing.assert_array_equal(model.bn_params[0]['running_var'], [2.0])

    def test_models_without_batchnorm_still_restore_the_best_weights(self):
        model = CounterModel()
        self.run_two_updates(model)
        np.testing.assert_array_equal(model.params['W'], [-1.0])


if __name__ == '__main__':
    unittest.main()
