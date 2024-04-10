# json-downloader-poweshell

json-downloader for powershell <img src="https://j2doll.github.io/j2doll/img/kr.png" /> ```파워셀을 이용한 json-downloader```

- json-downloader : https://github.com/JayTwoLab/json-downloader
- json-downloader for powershell : https://github.com/JayTwoLab/json-downloader-poweshell

## Feature <img src="https://j2doll.github.io/j2doll/img/kr.png" /> ```특징```

- It performs the function of downloading files from the following contents.

```json
{
	"https://raw.githubusercontent.com/j2doll/json-downloader/master/README.md" : "README.md" ,
	"https://raw.githubusercontent.com/j2doll/json-downloader/master/LICENSE" : "LICENSE" 
}
```

- :zap: Performs the function of decompressing downloaded file(s)

## Usage <img src="https://j2doll.github.io/j2doll/img/kr.png" /> ```사용법```

- :one: How to use it in Windows Command Prompt

 - Ability to only download files

```cmd
powershell -ExecutionPolicy Bypass -File main.ps1 json test.json
```

 - Ability to unzip the file after downloading it
 
```cmd
powershell -ExecutionPolicy Bypass -File main.ps1 7z test.json
``` 

- :two: How to use it in Powershell

 - Temporarily change policy in Powershell
 
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force
``` 

 - Ability to only download files

```ps1
.\main.ps1 json .\test.json
```

 - Ability to unzip the file after downloading it
 
```ps1
.\main.ps1 7z .\test.json
``` 

## License

- json-downloader-poweshell is under MIT License.

## Contact 

- https://github.com/JayTwoLab/json-downloader-poweshell

