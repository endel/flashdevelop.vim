" Sprouts AS3/Flex Compiler Utility
" Maintainer: Endel Dreyer <endel.dreyer@gmail.com>
" Last Change: 2012-02-20

if exists("current_compiler")
    finish
endif

let current_compiler = "sprouts"
let sproutsCmd = 'rake'

if exists("g:sproutsOptions")
  let sproutsCmd = sproutsCmd . ' ' . g:sproutsOptions
endif

let &l:makeprg=sproutsCmd

echomsg sproutsCmd
" setlocal errorformat=
"             \%f(%l):\ Error:\ %m
" setlocal errorformat=
"             \%-GLoading\ configuration\ file,
" 
setlocal errorformat=
            \%-GLoading\ configuration\ file,
            \%E%f(%l):\ \ Error:\ %m,
            \%W%f(%l):\ Warning:\ %m,
            \%+C%.%#
" Sample output
"
"Loading configuration file C:\Programs\Adobe\FlexBuilder3\sdks\3.1.0\frameworks\flex-config.xml
"C:\projects\flex\src\MMO.mxml(1991): Warning: Data binding will not be able to detect assignments to "sessionReportXML".
"
"				<mx:DataGrid id="dg_session_report" width="781" height="433" dataProvider="{sessionReportXML.row}" 
"
"C:\projects\flex\src\MMO.mxml(488):  Error: Access of undefined property debugFlexBuilderRun.
"
"                if( debugFlexBuilderRun ) {
"
"C:\projects\flex\src\MMO.mxml(495):  Error: Access of undefined property lastFaultMessage.
"
"                if( now.time - lastFaultMessage.time > 60000 ) {
"
"C:\projects\flex\src\MMO.mxml(498):  Error: Access of undefined property lastFaultMessage.
"
"                        lastFaultMessage = now;
"
"C:\projects\flex\src\MMO.mxml(501):  Error: Access of undefined property ServerMonitor.
"
"                        ServerMonitor.webServerDown();
" 

" vim: filetype=vim
