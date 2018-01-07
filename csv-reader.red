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
		text	[string!]		"CSV text"
		return:	[block!]	"A block of maps"
		/by							"Specify delimiter (default is comma)"
			delimiter	[string!]	"delimiter string"
		/no-header					"Do not read the first row as header"
		/columns					"Specify names of columns"
			names		[block!]	"A block of column names"
	][
		rows: split text lf
		unless by [delimiter: ","]

		headers: case [
			columns		[names]
			no-header	[collect [repeat i length? split rows/1 delimiter [keep i]]]
			true		[split rows/1 delimiter]
		]

		unless no-header [take rows]
		row-length: length? headers

		collect [foreach row rows [
				fields: split row delimiter
				keep make map! collect [repeat i row-length [
						val: either none? fields/:i [""][fields/:i]
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