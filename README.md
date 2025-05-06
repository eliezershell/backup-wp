# 🗂️ WordPress Backup & Restore Automation

Este repositório contém scripts de automação para **backup** e **restauração** de um servidor WordPress, incluindo arquivos do site e banco de dados MySQL.

> ⚠️ **Atenção:** Os dados e senhas utilizados nos exemplos são **fictícios** e foram incluídos apenas para fins didáticos.

---

## 📁 Arquivos

- **`backup.sh`**: Realiza o backup dos arquivos do WordPress e do banco de dados MySQL.
- **`restore.sh`**: Restaura os arquivos e o banco de dados a partir de um backup existente.
- **`.my.cnf`**: Arquivo de configuração com credenciais do MySQL para autenticação automática.

---

## 🔧 Requisitos

- Sistema baseado em Linux
- MySQL ou MariaDB
- WordPress instalado em `/var/www`
- Permissões adequadas para ler e escrever nos diretórios de backup

---

## 📦 Estrutura de Backup

Os backups são salvos em `/home/ubuntu/backup` com os seguintes formatos:

- `wordpress-files-YYYY-MM-DD.tar.gz`: Backup compactado dos arquivos do site.
- `wordpress-db-YYYY-MM-DD.sql`: Dump do banco de dados MySQL.

---

## ▶️ Uso dos Scripts

### 🔹 Executar o backup

```bash
./backup.sh
```

Esse comando irá:

- Criar o diretório de backup (se necessário)
- Compactar os arquivos do site
- Fazer o dump do banco de dados `eliezerdb`
- Registrar tudo em `/home/ubuntu/backup/backup.log`

---

### 🔹 Executar o restore

```bash
./restore.sh
```

Durante a execução, o script solicitará a **data do backup** desejado no formato `YYYY-MM-DD`. O script irá:

- Verificar se os arquivos de backup existem
- Fazer um backup preventivo dos arquivos e banco de dados atuais
- Restaurar os arquivos do site
- Restaurar o banco de dados MySQL

---

## 🔐 Sobre o `.my.cnf`

O arquivo `.my.cnf` permite o uso de comandos MySQL sem solicitar senha, contendo:

```ini
[client]
user=eliezer
password=eliezer-senha
```

> ❗ Recomendamos que este arquivo seja protegido com permissões restritas:
```bash
chmod 600 ~/.my.cnf
```

---

## 📝 Observações

- Os caminhos e nomes do banco de dados podem ser ajustados conforme a necessidade do seu ambiente.
- Os logs são gravados no arquivo `backup.log` dentro do diretório de backups.
- Recomenda-se agendar o `backup.sh` com um cron job para execução automática diária/semanal.
