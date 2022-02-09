# Backups

They use [Restic](https://restic.readthedocs.io) to manage the snapshots and
[Backblaze](https://www.backblaze.com/) to store them.

In each folder, copy the distribution file `env.dist` to `env` and fill the
variable values according to the folder. Create a `restic_password` file too
containing the restic password.

Setup the systemctl service and timer running the script `setup-timer.sh`.
