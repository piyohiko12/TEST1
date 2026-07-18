GitHubにSSHキーを登録する手順は次の3ステップです。

**1. キーを生成する**

ターミナルで次を実行します(メールアドレスは目印なので任意)。

```bash
ssh-keygen -t ed25519 -C "u12s20@gmail.com"
```

保存先を聞かれたらEnterで既定の`~/.ssh/id_ed25519`に保存し、パスフレーズは任意で設定します(推奨)。

**2. 公開鍵をコピーする**

```bash
cat ~/.ssh/id_ed25519.pub
```

表示された`ssh-ed25519 ...`の全文をコピーします(末尾のメールアドレスまで)。

**3. GitHubに登録する**

GitHubの Settings → SSH and GPG keys → New SSH key を開き、Titleに端末名など、Keyに先ほどの公開鍵を貼り付けて Add SSH key を押します。

登録後、`ssh -T git@github.com` で接続を確認できます。`Hi <ユーザー名>!` と表示されれば成功です。
