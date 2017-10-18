# SSon
A thing similar to a Gson(Swift)
JsonData -> Dictionary -> Model에 Mapping 하여 바로 사용할 수 있도록~!!
Network 통신 후 Json을 Parsing 할 필요 없이 Model에 Map 되도록 만들었다..
실제 사용 예는 Sample에 나와있다.

/**
 * 필수 Variable에 꼭 @objc 붙일것 -> @objc var text: String?          (Swift 4.0이상에선 필수)
 * or @objcMembers를 붙여서 사용한다.
 * 지원 타입 = String, String?, Int, Int64, Bool, NSArray, NSArray?, NSDictionary, NSDictionary?
 * 사용 금지 타입 = Int?, Int64?, Bool? (Objective-C -> Swift 타입으로 변경시 KVC 에러 발생)
**/

