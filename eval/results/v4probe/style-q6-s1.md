まずローカルで鍵を作り、公開鍵をGitHubに登録します。

**1. 鍵を生成**
```bash
ssh-keygen -t ed25519 -C "u12s20@gmail.com"
```
保存先とパスフレーズを聞かれますが、そのままEnterで進めて構いません（`~/.ssh/id_ed25519`と`.pub`が作られます）。

**2. 公開鍵をコピー**
```bash
cat ~/.ssh/id_ed25519.pub
```
出力された`ssh-ed25519 ...`の1行全体をコピーします。

**3. GitHubに登録**
GitHubの Settings → SSH and GPG keys → New SSH key を開き、コピーした内容を貼り付けて保存します。

**4. 接続確認**
```bash
ssh -T git@github.com
```
`Hi <ユーザー名>! You've successfully authenticated`と出れば完了です。

以降このマシンからは`git@github.com:...`形式のURLでパスワードなしにpush/pullできます。
