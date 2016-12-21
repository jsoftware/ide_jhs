0 : 0
table (spreadsheet) support is provided by Handsontable,
an open source javascript library released under MIT license
that is distributed as part of JHS

currently only a few features are exposed, but it would not
take much work to make a sophisticated spreadsheet application

examples create new tabs - close unnecessary tabs and move new tabs
so the jijx tab can be seen at the same time
)

n=. i.3 4
jtable 'T_n';'n'  NB. open T_n tab with spreadsheet display on n

0 : 0
edit cells and type in new cells to create new rows and cols
as original data was numeric, new non-numerics shows as red

pressing Save sets the noun - the result is boxed
and further validation and processing is your responsibility
)

s=: 2 2$'aa';'b';'c';'dd'
jtable 'T_s';'s'

jhslinkurl'www.handsontable.com'
