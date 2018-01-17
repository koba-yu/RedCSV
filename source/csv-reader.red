Red [
	Title: "Red CSV reader"
	Author: "Koba-yu"
	File: %csv-reader.red
	Tabs: 4
]

; Can not use context until the issue below resolved
; https://github.com/red/red/issues/3156

; csv-reader: context [
	map: function [
		"Make a block of maps by CSV text"
		text			[string!]				"CSV text"
		/by										"Specify delimiter (default is comma)"
			delimiter	[char! string! bitset!]	"delimiter string"
		/no-header								"Do not read the first row as header"
		/columns								"Specify names of columns"
			names		[map!]					"Map of column names"
		return:			[block!]				"A block of maps"
	][
		unless by [delimiter: ","]
		not-quote: charset [not {"}]
		normal-char: charset compose [not (rejoin [{"} delimiter lf])]

		values: parse text [collect [any [
					{"} copy val some {""} {"} keep (replace/all val {""} {"})
					| {"} copy val some [{""} | not-quote] {"} keep (replace/all val {""} {"})
					| keep lf
					| keep some normal-char
					| {"} {"} keep ({})
					| delimiter delimiter keep ({})
					| delimiter
				]
			]
		]

		rows: copy []
		while [not empty? values][
			append/only rows collect [
				until [
					val: take values
					unless lf?: equal? val lf [keep val]
					any [lf? empty? values]
				]
			]
		]

		headers: either no-header [
			collect [repeat i length? rows/1 [keep i]]
		][
			rows/1
		]

		if columns [headers: collect [foreach header headers [
					keep either none? names/:header [header][names/:header]
				]
			]
		]

		unless no-header [take rows]
		row-length: length? headers

		collect [foreach row rows [
				keep make map! collect [repeat i row-length [
						if none? val: row/:i [val: ""]
						keep reduce [
							either maybe-word: attempt [
								to word! headers/:i
							][maybe-word][headers/:i] val
						]
					]
				]
			]
		]
	]
; ]