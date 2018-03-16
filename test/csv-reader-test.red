Red [
	Title: "csv reader test"
	Author: "Koba-yu"
	File: %csv-reader-test.red
	Tabs: 4
]

do %../source/csv-reader.red

tests: make map! [

	test1: [
		ret: csv/map {name,age,city
Taro,20,Tokyo
Jiro,30,Osaka}

		all [
			equal? ret/1 #(
				name: "Taro"
				age: "20"
				city: "Tokyo"
			)
			equal? ret/2 #(
				name: "Jiro"
				age: "30"
				city: "Osaka"
			)
		]
	]

	test2: [
		ret: csv/map/no-header {Taro,20,Tokyo
Jiro,30,Osaka}

		all [
			equal? ret/1 #(
				1 "Taro"
				2 "20"
				3 "Tokyo"
			)

			equal? ret/2 #(
				1 "Jiro"
				2 "30"
				3 "Osaka"
			)
		]
	]

	test3: [
		ret: csv/map/by {name^-age^-city
Taro^-20^-Tokyo
Jiro^-30^-Osaka} "^-"

		all [
			equal? ret/1 #(
				name: "Taro"
				age: "20"
				city: "Tokyo"
			)
			equal? ret/2 #(
				name: "Jiro"
				age: "30"
				city: "Osaka"
			)
		]
	]

	test4: [
		ret: csv/map/no-header/columns {Taro,20,Tokyo
Jiro,30,Osaka} #(
	1 'name
	2 'age
	3 'city
)
		all [
			equal? ret/1 #(
				name: "Taro"
				age: "20"
				city: "Tokyo"
			)
			equal? ret/2 #(
				name: "Jiro"
				age: "30"
				city: "Osaka"
			)
		]
	]

	test5: [
		ret: csv/map/no-header {"abc","a,d",,"",15,"""","ab""c","""""","a
b"
"abc","a,d",,"",15,"""","ab""c","""""","a
b"}
		all [
			equal? ret/1 #(
				1 "abc"
				2 "a,d"
				3 ""
				4 ""
				5 "15"
				6 {"}
				7 {ab"c}
				8 {""}
				9 {a
b}
			)

			equal? ret/2 #(
				1 "abc"
				2 "a,d"
				3 ""
				4 ""
				5 "15"
				6 {"}
				7 {ab"c}
				8 {""}
				9 {a
b}
			)
		]
	]

]

result: collect [foreach test keys-of tests [
		unless do tests/:test [keep rejoin [test " is failed"]]
	]
]

print either empty? result ["All passed"][result]