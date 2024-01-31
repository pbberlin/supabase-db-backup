# supabase-db-backup

* Using github actions to create a postgres dump

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



