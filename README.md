# S3 upload/download scripts

Here's how I use this:

- Create a directory on your machine for a bucket/client
- Create a symlink in that directory called `sync.sh` pointing at `sync.sh` in the checked out copy of this repo
- Create a file called `sync.config` and set up configs for the bucket/client (see `sync.config.sample`)
- Run `sync.sh download` to get current files
- Edit files
- Run `sync.sh upload` to upload your changes (you will be prompted for each file)