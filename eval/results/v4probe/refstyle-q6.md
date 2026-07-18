手順は3つです。

1. キーを生成(ターミナルで実行、質問はEnterでOK):
```bash
ssh-keygen -t ed25519 -C "u12s20@gmail.com"
```

2. 公開鍵を表示してコピー:
```bash
cat ~/.ssh/id_ed25519.pub
```
(Windowsのコマンドプロンプトなら `type %USERPROFILE%\.ssh\id_ed25519.pub`)

3. GitHubの Settings → SSH and GPG keys → New SSH key を開き、コピーした内容をKey欄に貼り付けて保存。

`ssh -T git@github.com` を実行して「Hi ユーザー名!」と表示されれば登録完了です。
