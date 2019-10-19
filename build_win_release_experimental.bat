@echo off
cd /d "%~dp0"
mkdir release\experimental
del /Q release\experimental\*
call build_set_protobuf_directories.bat
"%PROTOC_X86_EXE%" -I.\dll\ --cpp_out=.\dll\ .\dll\net.proto
call build_env_x86.bat
cl dll/rtlgenrandom.c dll/rtlgenrandom.def
cl /LD /DEMU_RELEASE_BUILD /DEMU_EXPERIMENTAL_BUILD /DCONTROLLER_SUPPORT /DNDEBUG /I%PROTOBUF_X86_DIRECTORY%\include\ dll/*.cpp dll/*.cc detours/*.cpp controller/gamepad.c "%PROTOBUF_X86_LIBRARY%" Iphlpapi.lib Ws2_32.lib rtlgenrandom.lib Shell32.lib /EHsc /MP12 /Ox /link /debug:none /OUT:release\experimental\steam_api.dll
cl /LD /DEMU_RELEASE_BUILD /DEMU_EXPERIMENTAL_BUILD /DNDEBUG steamclient.cpp /EHsc /MP12 /Ox /link /OUT:release\experimental\steamclient.dll
"%PROTOC_X64_EXE%" -I.\dll\ --cpp_out=.\dll\ .\dll\net.proto
call build_env_x64.bat
cl dll/rtlgenrandom.c dll/rtlgenrandom.def
cl /LD /DEMU_RELEASE_BUILD /DEMU_EXPERIMENTAL_BUILD /DCONTROLLER_SUPPORT /DNDEBUG /I%PROTOBUF_X64_DIRECTORY%\include\ dll/*.cpp dll/*.cc detours/*.cpp controller/gamepad.c "%PROTOBUF_X64_LIBRARY%" Iphlpapi.lib Ws2_32.lib rtlgenrandom.lib Shell32.lib /EHsc /MP12 /Ox /link /debug:none /OUT:release\experimental\steam_api64.dll
cl /LD /DEMU_RELEASE_BUILD /DEMU_EXPERIMENTAL_BUILD /DNDEBUG steamclient.cpp /EHsc /MP12 /Ox /link /OUT:release\experimental\steamclient64.dll
copy Readme_experimental.txt release\experimental\Readme.txt
