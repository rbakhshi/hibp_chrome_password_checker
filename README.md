# Check your passwords against [HaveIBeenPwnd](https://haveibeenpwned.com/)
Ruby script to check if your list of passwords stored in Chrome have been leaked somewhere on the web.

This is a very simple ruby script. 

## Input file format

This is based on how Chrome password export file is, which is a CSV with following columns

```
   name,url,username,password
```

## How to use it?
1. Export your passwords from Chrome
2. Run the script and pass the password file name as the first arguemnt. It defaults to "./Chrome Passwords.csv"
3. run the script! WARNING: it will print last 5 characters of your passwords to the standard output!

## License
MIT

## Bugs? Improvements?
Feel free to open pull requests



