Red [
	Title: "csv reader test"
	Author: "Koba-yu"
	File: %csv-reader-test.red
	Tabs: 4
]

do %../source/csv-reader.red

tests: make map! [

	test1: [
		ret: map {name,age,city
Taro,20,Tokyo
Jiro,30,Osaka}

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

	test2: [
		ret: map/no-header {Taro,20,Tokyo
Jiro,30,Osaka}

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

	test3: [
		ret: map/by {name^-age^-city
Taro^-20^-Tokyo
Jiro^-30^-Osaka} "^-"

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

	test4: [
		ret: map/no-header/columns {Taro,20,Tokyo
Jiro,30,Osaka} #(
	1 'name
	2 'age
	3 'city
)

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

result: collect [foreach test keys-of tests [
		unless do tests/:test [keep rejoin [ test " is failed"]]
	]
]

print either empty? result ["All passed"][result]