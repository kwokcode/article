
##代码如下
``` go
package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	flag.Parse() //CommandLine.Parse(os.Args[1:]) 目的去除命令行
	fmt.Print("flag = %v",flag.Args())
	for key, value := range flag.Args() {
		fmt.Print(" key = %v valeu = %v",key,value)
	}
	helper := ReplaceHelper{
		Root: flag.Arg(0),
		OldText: flag.Arg(1),
		NewText: flag.Arg(2),
	}
	if helper.OldText == helper.NewText{
		fmt.Println("error !! the NewText isEqual the OldText")
		return
	}
	err := helper.DoWrok()
	if err == nil {
		fmt.Print("done!")
	} else {
		fmt.Print("error:", err.Error())
	}

}
type ReplaceHelper struct {
	Root    string //根目录
	OldText string //需要替换的文本
	NewText string //新的文本
}
func (h *ReplaceHelper) DoWrok() error {

	return filepath.Walk(h.Root, h.walkCallback)

}

func (h ReplaceHelper) walkCallback(path string, f os.FileInfo, err error) error {

	if err != nil {
		return err
	}
	if f == nil {
		return nil
	}
	if f.IsDir() {
		fmt.Println("DIR:",path)
		return nil
	}

	//文件类型需要进行过滤

	buf, err := ioutil.ReadFile(path)
	if err != nil {
		//err
		return err
	}
	content := string(buf)
	fmt.Printf("h.OldText: %s \n",h.OldText)
	fmt.Printf("h.NewText: %s \n",h.NewText)

	//替换
	newContent := strings.Replace(content, h.OldText, h.NewText, -1)

	//重新写入
	ioutil.WriteFile(path, []byte(newContent), 0)

	return err
}
```

## 通过文件路径进行替换
``` go 
package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	flag.Parse()
	helper := ReplaceHelper{
		Root:        flag.Arg(0),
		OldFilePath: flag.Arg(1),
		NewFilePath: flag.Arg(2),
	}
	if helper.OldFilePath == helper.NewFilePath{
		fmt.Println("error !! the OldFilePath isEqual the NewFilePath")
		return
	}
	if IsDir(helper.Root) != true &&   IsDir(helper.NewFilePath) != true &&  IsDir(helper.OldFilePath)!= true {
		fmt.Println("error !! the Root OldFilePath  NewFilePath some one is Dir ")
		return
	}
	err := helper.DoWrok()
	if err == nil {
		fmt.Print("done!")
	} else {
		fmt.Print("error:", err.Error())
	}


}

// 判断所给路径是否为文件夹  
func IsDir(path string) bool {
	s, err := os.Stat(path)
	if err != nil {
		return false
	}
	return s.IsDir()
}
type ReplaceHelper struct {
	Root        string //根目录
	OldFilePath string //需要替换的目录
	NewFilePath string //新的文本目录
}
func (h *ReplaceHelper) DoWrok() error {

	return filepath.Walk(h.Root, h.walkCallback)

}

func (h ReplaceHelper) walkCallback(path string, f os.FileInfo, err error) error {

	if err != nil {
		return err
	}
	if f == nil {
		return nil
	}
	if f.IsDir() {
		fmt.Println("DIR:",path)
		return nil
	}

	//文件类型需要进行过滤

	buf, err := ioutil.ReadFile(path)
	if err != nil {
		//err
		return err
	}
	content := string(buf)

	bufOld, err := ioutil.ReadFile( h.OldFilePath)
	if err != nil {
		//err
		return err
	}
	contentOld := string(bufOld)
	bufNew, err := ioutil.ReadFile(h.NewFilePath)
	if err != nil {
		//err
		return err
	}
	contentNew := string(bufNew)

	//替换

	fmt.Printf("contentOld = \n%v \n contentNew = \n%v",contentOld,contentNew)
	newContent := strings.Replace(content, contentOld, contentNew, -1)

	//重新写入
	ioutil.WriteFile(path, []byte(newContent), 0)

	return err
}
```
