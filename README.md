# LunarDatePicker
基于UIpickerView封装实现的可带农历和世纪选择展示的日期选择器
# Effect
![Simulator Screen Shot - iPhone 14 Pro - 2023-06-16 at 14 45 45](https://github.com/fuyud/LunarDatePicker/assets/18585141/cafebe5b-d553-4228-8464-7fd628c3cc3a)
![Simulator Screen Shot - iPhone 14 Pro - 2023-06-16 at 14 47 01](https://github.com/fuyud/LunarDatePicker/assets/18585141/c4b22932-9efa-452f-9b6b-338a7b232a05)
![Simulator Screen Shot - iPhone 14 Pro - 2023-06-16 at 14 49 27](https://github.com/fuyud/LunarDatePicker/assets/18585141/8d3a4603-c45d-4941-be7f-3f0b1bdd3d34)
![Simulator Screen Shot - iPhone 14 Pro - 2023-06-16 at 14 49 35](https://github.com/fuyud/LunarDatePicker/assets/18585141/99ad7716-a1cc-4660-bff6-d0d6bcbdbce5)
# Use example
农历带世纪筛选日期选择器
```Swift
CPLunarDatePickerView.showPickerView(title: "请选择") { res in
    if res?.isUnkonwn ?? false {
        print("不详")
        return
    }
    print("阳历" + (res?.value ?? ""))
    print("农历" + (res?.value1 ?? ""))
}
```
普通日期选择器
```Swift
CPDatePickerView.showPickerView { res in
    print("选择日期" + (res ?? ""))
}
```
字符串选择器
```Swift
CPStringPickerView.showPickerView(stringDatasource: CPPickerManager.lunarMonths) { res in
		print("选择index：" + "\(res?.index ?? 0)")
		print("选择value：" + (res?.value ?? ""))
}
```
