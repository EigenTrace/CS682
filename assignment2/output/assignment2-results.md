# Assignment 2 completion and measured results

All five notebooks have completed implementations, written answers, saved outputs, and plots. The runs use the existing `ai` Python environment and the local CIFAR-10 dataset. Exact tested package versions are recorded in [environment.json](environment.json).

| Notebook | Main verified result |
|---|---|
| FullyConnectedNets | Two-layer validation accuracy 53.2%; best fully connected model 55.1% validation and 55.6% test accuracy. Both 50-image exercises reached 100% training accuracy within 20 epochs. |
| BatchNormalization | Forward/backward and full-network gradient checks completed; all 20 initialization scales and both batch-size experiments executed; all four written answers completed. |
| Dropout | Forward/backward and network gradient checks completed. With keep probability 0.25, best validation accuracy increased from 32.5% to 35.2% in the supplied experiment. All three written answers are completed. |
| ConvolutionalNetworks | Overfit 100 images to 100% training accuracy; after one full CIFAR-10 epoch, full training accuracy was 48.21% and validation accuracy was 48.9%. |
| PyTorch | All six one-epoch baselines completed. The challenge first cleared 70% validation accuracy at epoch 4 and reached 83.0% at epoch 10. The selected model's one final test evaluation was 81.45%. |

The fully connected notebook's test evaluation uses its provided 1,000-example test subset. The PyTorch notebook uses the full 10,000-example test split. Validation data selects checkpoints; test results are reported after selection.

## Supporting code

- Completed fully connected and convolutional model initialization, forward passes, losses, gradients, and weight-only L2 regularization.
- Completed normalization, dropout, convolution, pooling, spatial BatchNorm, GroupNorm, and momentum updates.
- Used matrix multiplication for affine layers to make the full CPU experiments practical.
- Fixed `Solver` so the selected BatchNorm checkpoint restores running statistics together with its weights; two regression checks cover models with and without BatchNorm.
- Fixed the supplied BatchNorm/LayerNorm numerical-gradient lambdas so they actually perturb the scale and shift parameters.
- Made notebook setup work locally and added missing library dependencies to `requirements.txt`.

Finite-difference diagnostics remain visible in the notebooks. ReLU/non-smooth or very small-gradient cases are interpreted using the notebook's tolerances and explicit smaller-step or absolute-error checks.

## Saved models and metrics

- [Fully connected model](fully_connected/best_model.pkl) and [metrics](fully_connected/training_metrics.json).
- [NumPy CNN parameters](cnn/three_layer_convnet_params.npz) and [metrics](cnn/training_metrics.json).
- [PyTorch model](pytorch/best_model.pt) and [epoch history](pytorch/challenge_history.json).

Open the notebooks with the `ai` environment selected as their kernel. Their setup cells accept either the project root or the `assignment2` directory. The CIFAR-10 files are expected under `cs682/datasets/cifar-10-batches-py`.

From `assignment2`, run the checkpoint regression checks with:

```bash
PYTHONPATH=. python -m unittest discover -s tests -v
```
