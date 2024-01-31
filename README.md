# supabase-db-backup

* Using github actions to create a postgres dump

* Run github actions _locally_ using [nektos act](https://github.com/nektos/act)

* [Supabase docs](https://supabase.com/docs/guides/cli/github-action/backups)

* [Github secrets](https://www.howtogeek.com/devops/what-are-github-secrets-and-how-do-you-use-them/)


* Github repo > Settings 
  * Security > Secrets and variables > Actions
  * Repository secrets
  *   i.e. AWS_KEY_ID

```yaml
my_setting:   ${{secrets.SECRET_NAME}}
for_instance: ${{secrets.AWS_KEY_ID}}
for_instance: ${{secrets.SB_DB_URL_1}}
```

* See .github/workflows/supa-backup.yml

## Nektos act

* Running github actions locally

* At least under windows, a docker daemon is required

```bash
scoop install act
act -l
# act -j test
act -j run_db_backup
```