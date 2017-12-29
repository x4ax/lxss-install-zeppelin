# lxss-install-zeppelin
Step by step guide how to install hadoop/spark/zeppelin on Linux subsystem for Windows 10

```lnx-user-name``` - regular lxss user (other than root)
```win-user-name``` - windows user hosting lxss
 
# Full lxss reinstall (optional)

In Windows cmd or PowerShell: 
```bash
> lxrun /uninstall /full /y
> rm -rf C:\Users\win-user-name\AppData\Local\lxss
> lxrun /install /y
> lxrun /setdefaultuser lnx-user-name
```

# Reset lxss user password (optional)

In Windows cmd or PowerShell, set default lxss user to root: 
```bash
> lxrun /setdefaultuser root
```
in bash, change password of the regular lxss user
```bash
$ passwd lnx-user-name
```
in Windows cmd or PowerShell, set default lxss user to the regular user:
```bash
> lxrun /setdefaultuser lnx-user-name
```
 