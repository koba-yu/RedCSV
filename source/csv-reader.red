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
		rows: split text lf
		unless by [delimiter: ","]

		headers: either no-header [
			collect [repeat i length? split rows/1 delimiter [keep i]]
		][
			split rows/1 delimiter
		]

		if columns [headers: collect [foreach header headers [
					keep either none? names/:header [header][names/:header]
				]
			]
		]

		unless no-header [take rows]
		row-length: length? headers

		collect [foreach row rows [
				fields: split row delimiter
				keep make map! collect [repeat i row-length [
						if none? val: fields/:i [val: ""]
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