# sql-server-tutorial

## environment
- [macOS 10.14.6](https://www.apple.com/tw/macos/mojave/)
- [Windows 10(1903)](https://www.microsoft.com/zh-tw/software-download/windows10ISO)
- [SQL Server 2017](https://www.microsoft.com/zh-tw/sql-server/sql-server-downloads)
- [SSMS 18.1](https://docs.microsoft.com/zh-tw/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017)

## [SQL Server](https://docs.microsoft.com/zh-tw/sql/sql-server/sql-server-technical-documentation?view=sql-server-2017)

## [Docker - SQL Server](https://hub.docker.com/_/microsoft-mssql-server)
1. Install [Docker SQL Server](https://docs.microsoft.com/zh-tw/sql/linux/quickstart-install-connect-docker?view=sql-server-2017)
```shell
sudo docker pull mcr.microsoft.com/mssql/server:2017-latest
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=<Your Passw0rd>' \
   -p 1433:1433 --name mymssql \
   -d mcr.microsoft.com/mssql/server:2017-latest
```

2. Install [django-pyodbc-azure](https://github.com/michiya/django-pyodbc-azure)
```shell
pip install django-pyodbc-azure
```

3. Install [ODBC Driver](https://docs.microsoft.com/zh-tw/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server)
```shell
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install msodbcsql mssql-tools
```