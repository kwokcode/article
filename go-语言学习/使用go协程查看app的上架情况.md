```
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"
)

var androidCh = make(chan int)

type ChannelInfo struct {
	ChannelName string `json:channelName`
	ChannelUrl  string `json:channelUrl`
	MustCompile string `json:mustCompile`
}

func main() {

	var infArray []ChannelInfo

jsonstr := `[
    {
        "channelName":"baidu",
        "channelUrl":"https://shouji.baidu.com/software/26050113.html",
        "mustCompile":"版本: \\d\\.\\d.\\d"
    },
    {
        "channelName":"vivo",
        "channelUrl":"http://info.appstore.vivo.com.cn/detail/53311",
        "mustCompile":"版本：\\d\\.\\d.\\d"
    },
    {
        "channelName":"meizu",
        "channelUrl":"http://app.meizu.com/apps/public/detail?package_name=com.xiangha",
        "mustCompile":"\\d\\.\\d.\\d"
    },
    {
        "channelName":"huawei",
        "channelUrl":"https://appstore.huawei.com/app/C189595",
        "mustCompile":"版本： <span>\\d\\.\\d.\\d"
    },
    {
        "channelName":"wandoujia",
        "channelUrl":"https://www.wandoujia.com/apps/com.xiangha",
        "mustCompile":"</dt><dd>&nbsp;\\d\\.\\d.\\d"
    },
    {
        "channelName":"xiaomi",
        "channelUrl":"http://app.xiaomi.com/detail/34140",
        "mustCompile":"版本号：</li><li>\\d\\.\\d.\\d"
    },
    {
        "channelName":"360",
        "channelUrl":"http://zhushou.360.cn/detail/index/soft_id/245542",
        "mustCompile":"版本：</strong>\\d\\.\\d.\\d"
    },
    {
        "channelName":"应用宝",
        "channelUrl":"https://sj.qq.com/myapp/detail.htm?apkName=com.xiangha",
        "mustCompile":"\"det-othinfo-data\">V\\d\\.\\d.\\d"
    }
]`
	if err:=json.Unmarshal([]byte(jsonstr),&infArray);err!=nil{

		fmt.Println("解析错误")
		return

	}

	for _, v := range infArray {
		go GetVesion(v)
	}
	for i, _ := range infArray {
		//go getVesion(v)
		i++
		<-androidCh

	}
}
func GetVesion(channelInfo ChannelInfo) {

	re, error := HttpUaGet(channelInfo.ChannelUrl)
	if error != nil {
		fmt.Println("error", error)
	}
	//fmt.Println(re)
	//解释正则表达r式 \d\.\d就是 数字.数字 的意思
	reg := regexp.MustCompile(channelInfo.MustCompile) //编译规则
	if reg == nil {
		fmt.Println("MustCompile err")
		return
	}

	//返回数组里面是字符串
	resultArray := reg.FindAllString(re, -1) //根据规则匹配buf中字符
	if len(resultArray) > 0 {
		resultStr := resultArray[0]
		if len(resultStr) > 0 {
			reg := regexp.MustCompile(`\d\.\d.\d`) //编译规则
			if reg == nil {
				fmt.Println("MustCompile err")
				return
			}
			resultArray := reg.FindAllString(resultStr, -1) //根据规则匹配buf中字符
			fmt.Println(channelInfo.ChannelName, "\t->\t版本号:", resultArray)
		}
	}else {
		fmt.Println("诶呀 错了 ",channelInfo.ChannelName)
	}

	androidCh <- 1
}
func HttpUaGet(url string) (result string, err error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		log.Fatalln(err)
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36")

	resp, eror := client.Do(req)
	if err != nil {
		err = eror
		return
	}
	buf := make([]byte, 4*1024)
	for {
		n, _ := resp.Body.Read(buf)
		if n == 0 {
			break
		}
		result += string(buf[:n])
	}
	defer resp.Body.Close()
	return
}

```
运行结果
```
360 	->	版本号: [7.4.0]
vivo 	->	版本号: [7.4.0]
meizu 	->	版本号: [7.4.0]
xiaomi 	->	版本号: [7.4.0]
应用宝 	->	版本号: [7.4.0]
huawei 	->	版本号: [7.4.0]
baidu 	->	版本号: [7.4.0]
wandoujia 	->	版本号: [7.4.0]
```
