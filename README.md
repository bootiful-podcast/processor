# README


## Running the Python Program

This program uses `pipenv` to manage dependencies and to setup a virtual environment. If you don't already have `pipenv` installed, 
you can install it using `pip install pipenv`. If you don't have `pip` installed, install that using your operating 
system's package manager. Then run `pipenv install` in the root of the project. You can create a new shell that's got 
the correct Python version and dependencies loaded using `pipenv shell`.

## Travis CI 

The deployment for this program requires some sensitive information including, but not limited to, a
.pem file generated from AWS and the contents of a valid `$HOME/.aws/config` and `$HOME/.aws/credentials`.

I used incantations like this to encrypt the relevant files.

```bash
travis encrypt-file my.pem     
``` 


This will dump a file suffixed in `.enc` which we then can check into the Git repository. On the build server, in the `.travis.yml` file,
we then run incantations like `openssl aes-256-cbc -K $encrypted_58bca13bc34f_key -iv $encrypted_58bca13bc34f_iv -in my.pem.enc -out my.pem -d`. 
This dumps the associated config into a file on the build server which we can then use in our build.


## AWS 

I did two things to make this work. I went to `EC2 Dashboard`, and then `Key Pairs`. 
Then I generated a new keypair and downloaded the resulting `.pem` file. You'll need to encrypt this file and make 
sure its available for your Travis CI build. I ran `travis encrypt-file my.pem`. That gave me an `openssl` command I could 
then run in the build to re-hydrate  the encrypted key in my build environment. 

You also need to update the `processor.tf` variable `key_name` to point to the new `Key Pair Name`.  

The Terraform script uses an S3 bucket to persist the Terraform state so that it knows what's been deployed and what'd need to be destroyed. 
It will look for an S3 bucket `podcast-terraform-state`. Ensure that you have this bucket configured (and that it's versioned!). 


