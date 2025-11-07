-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             LocalDictation [19893]
Path:                /Users/USER/*/LocalDictation.app/Contents/MacOS/LocalDictation
Identifier:          com.yourname.LocalDictation
Version:             1.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      zsh [99712]
Coalition:           com.todesktop.230313mzl4w4u92 [32341]
Responsible Process: Cursor [68434]
User ID:             501

Date/Time:           2025-11-07 13:39:10.3483 -0600
Launch Time:         2025-11-07 13:37:52.6045 -0600
Hardware Model:      Mac16,12
OS Version:          macOS 26.1 (25B78)
Release Type:        User

Crash Reporter Key:  C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2
Incident Identifier: DCA58AF7-1D3F-4C62-A2C1-163A65EA2E2D

Sleep/Wake UUID:       DD9B40A7-79AE-495C-B972-70C6C7761451

Time Awake Since Boot: 100000 seconds
Time Since Wake:       17648 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_CRASH (SIGABRT)
Exception Codes:   0x0000000000000000, 0x0000000000000000

Termination Reason:  Namespace SIGNAL, Code 6, Abort trap: 6
Terminating Process: LocalDictation [19893]


Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   libsystem_kernel.dylib        	       0x1860e6c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1860f9028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1860ef98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x1860e6fb4 mach_msg + 24
4   CoreFoundation                	       0x1861c8b90 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x1861c74e8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18628135c _CFRunLoopRunSpecificWithOptions + 532
7   HIToolbox                     	       0x192c84768 RunCurrentEventLoopInMode + 316
8   HIToolbox                     	       0x192c87a90 ReceiveNextEventCommon + 488
9   HIToolbox                     	       0x192e11308 _BlockUntilNextEventMatchingListInMode + 48
10  AppKit                        	       0x18aad83c0 _DPSBlockUntilNextEventMatchingListInMode + 236
11  AppKit                        	       0x18a5d1e34 _DPSNextEvent + 588
12  AppKit                        	       0x18b09ff44 -[NSApplication(NSEventRouting) _nextEventMatchingEventMask:untilDate:inMode:dequeue:] + 688
13  AppKit                        	       0x18b09fc50 -[NSApplication(NSEventRouting) nextEventMatchingMask:untilDate:inMode:dequeue:] + 72
14  AppKit                        	       0x18a5ca780 -[NSApplication run] + 368
15  AppKit                        	       0x18a5b66dc NSApplicationMain + 880
16  SwiftUI                       	       0x1b9d62110 specialized runApp(_:) + 168
17  SwiftUI                       	       0x1ba11b2b0 runApp<A>(_:) + 112
18  SwiftUI                       	       0x1ba3e4d54 static App.main() + 224
19  LocalDictation                	       0x1003ce9cc static LocalDictationApp.$main() + 40
20  LocalDictation                	       0x1003cec38 main + 12
21  dyld                          	       0x185d61d54 start + 7184

Thread 1:: com.apple.NSEventThread
0   libsystem_kernel.dylib        	       0x1860e6c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1860f9028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1860ef98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x1860e6fb4 mach_msg + 24
4   CoreFoundation                	       0x1861c8b90 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x1861c74e8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18628135c _CFRunLoopRunSpecificWithOptions + 532
7   AppKit                        	       0x18a661cb4 _NSEventThread + 184
8   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
9   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 2:: caulk.messenger.shared:17
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 3:: caulk.messenger.shared:high
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 4:: com.apple.audio.toolbox.AUScheduledParameterRefresher
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 5:: caulk::deferred_logger
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 6:

Thread 7::  Dispatch queue: com.LocalDictation.DebugLogger
0   libicucore.A.dylib            	       0x189eb93f8 icu::UnicodeString::setTo(char16_t*, int, int) + 268
1   libicucore.A.dylib            	       0x18a032d58 udat_format + 172
2   CoreFoundation                	       0x1861f1e40 CFDateFormatterCreateStringWithAbsoluteTime + 192
3   Foundation                    	       0x188342d54 -[NSDateFormatter stringForObjectValue:] + 292
4   LocalDictation                	       0x1003864cc closure #1 in DebugLogger.log(_:file:function:line:level:) + 660 (DebugLogger.swift:77)
5   LocalDictation                	       0x100386e00 partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:) + 60
6   LocalDictation                	       0x100386f94 thunk for @escaping @callee_guaranteed @Sendable () -> () + 48
7   libdispatch.dylib             	       0x185f6cb5c _dispatch_call_block_and_release + 32
8   libdispatch.dylib             	       0x185f86ac4 _dispatch_client_callout + 16
9   libdispatch.dylib             	       0x185f754e8 _dispatch_lane_serial_drain + 740
10  libdispatch.dylib             	       0x185f75fc4 _dispatch_lane_invoke + 388
11  libdispatch.dylib             	       0x185f80474 _dispatch_root_queue_drain_deferred_wlh + 292
12  libdispatch.dylib             	       0x185f7fd6c _dispatch_workloop_worker_thread + 692
13  libsystem_pthread.dylib       	       0x186125e4c _pthread_wqthread + 292
14  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 8:

Thread 9::  Dispatch queue: com.apple.root.default-qos
0   libsystem_kernel.dylib        	       0x18611a3d0 abort_with_payload_wrapper_internal + 136
1   libsystem_kernel.dylib        	       0x18611a3e4 abort_with_payload + 16
2   TCC                           	       0x18c8d5e94 __TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION__ + 172
3   TCC                           	       0x18c8d67e0 __TCCAccessRequest_block_invoke.229 + 628
4   TCC                           	       0x18c8d382c __tccd_send_message_block_invoke + 632
5   libxpc.dylib                  	       0x185e0be74 _xpc_connection_reply_callout + 124
6   libxpc.dylib                  	       0x185e0bd68 _xpc_connection_call_reply_async + 96
7   libdispatch.dylib             	       0x185f86af4 <deduplicated_symbol> + 16
8   libdispatch.dylib             	       0x185f8aae8 _dispatch_mach_msg_async_reply_invoke + 340
9   libdispatch.dylib             	       0x185f8017c _dispatch_root_queue_drain_deferred_item + 216
10  libdispatch.dylib             	       0x185f7f9e4 _dispatch_kevent_worker_thread + 520
11  libsystem_pthread.dylib       	       0x186125e84 _pthread_wqthread + 348
12  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 10:

Thread 11:

Thread 12:

Thread 13:

Thread 14:

Thread 15:


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000010004005   x1: 0x0000000507000806   x2: 0x0000000200000000   x3: 0x00001d0300000000
    x4: 0x0000000000000000   x5: 0x00001d0300000000   x6: 0x0000000000000002   x7: 0x00000000ffffffff
    x8: 0x0000000000000000   x9: 0x0000000400000000  x10: 0x0000000000000000  x11: 0x0000000000000002
   x12: 0x0000000000000000  x13: 0x0000000000000000  x14: 0x0000000000001d03  x15: 0x0000000000000000
   x16: 0xffffffffffffffd1  x17: 0x00000001f40f1af0  x18: 0x0000000000000000  x19: 0x00000000ffffffff
   x20: 0x0000000000000002  x21: 0x00001d0300000000  x22: 0x0000000000000000  x23: 0x00001d0300000000
   x24: 0x000000016fa8d358  x25: 0x0000000200000000  x26: 0x0000000507000806  x27: 0xfffffffffffffbbf
   x28: 0x0000000107000806   fp: 0x000000016fa8d2c0   lr: 0x00000001860f9028
    sp: 0x000000016fa8d270   pc: 0x00000001860e6c34 cpsr: 0x00000000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x100370000 -        0x10042bfff LocalDictation (*) <fe444e5f-c0d0-36ed-b56e-235d4b762245> */LocalDictation.app/Contents/MacOS/LocalDictation
       0x10e030000 -        0x10e173fff com.apple.audio.units.Components (1.14) <9155d5f9-804c-3e9b-a2d9-b4ccff316f05> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
       0x10dda8000 -        0x10ddb3fff libobjc-trampolines.dylib (*) <f8bd9069-8c4f-37ea-af9a-2b1060f54e4f> /usr/lib/libobjc-trampolines.dylib
       0x119b64000 -        0x11a38bfff com.apple.AGXMetalG16G-B0 (341.11) <a22549f3-d4f5-3b88-af18-e06837f0d352> /System/Library/Extensions/AGXMetalG16G_B0.bundle/Contents/MacOS/AGXMetalG16G_B0
       0x1860e6000 -        0x18612249f libsystem_kernel.dylib (*) <9fe7c84d-0c2b-363f-bee5-6fd76d67a227> /usr/lib/system/libsystem_kernel.dylib
       0x186169000 -        0x1866afabf com.apple.CoreFoundation (6.9) <3c4a3add-9e48-33da-82ee-80520e6cbe3b> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x192bc3000 -        0x192ec57ff com.apple.HIToolbox (2.1.1) <9ab64c08-0685-3a0d-9a7e-83e7a1e9ebb4> /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/HIToolbox
       0x18a5b2000 -        0x18bcdeb9f com.apple.AppKit (6.9) <3c0949bb-e361-369a-80b7-17440eb09e98> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x1b9c51000 -        0x1bb3905bf com.apple.SwiftUI (7.1.13.1.401) <6a83fd25-8f6d-3773-9285-cea41ce49fb5> /System/Library/Frameworks/SwiftUI.framework/Versions/A/SwiftUI
       0x185d59000 -        0x185df7f63 dyld (*) <b50f5a1a-be81-3068-92e1-3554f2be478a> /usr/lib/dyld
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x186123000 -        0x18612fabb libsystem_pthread.dylib (*) <e95973b8-824c-361e-adf4-390747c40897> /usr/lib/system/libsystem_pthread.dylib
       0x19270c000 -        0x192734d7f com.apple.audio.caulk (1.0) <9c791aec-e0d3-3ace-ac9e-e7a4d59b7762> /System/Library/PrivateFrameworks/caulk.framework/Versions/A/caulk
       0x189e01000 -        0x18a0d2819 libicucore.A.dylib (*) <ec990bc7-956f-300a-8870-118269cb7e73> /usr/lib/libicucore.A.dylib
       0x1879b3000 -        0x18895625f com.apple.Foundation (6.9) <00467f1f-216a-36fe-8587-c820c7e0437d> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
       0x185f6b000 -        0x185fb1e9f libdispatch.dylib (*) <8fb392ae-401f-399a-96ae-41531cf91162> /usr/lib/system/libdispatch.dylib
       0x18c8d1000 -        0x18c8f5be3 com.apple.TCC (1.0) <bf63fec0-56e5-37ba-b7d4-629ea4c8114a> /System/Library/PrivateFrameworks/TCC.framework/Versions/A/TCC
       0x185dfc000 -        0x185e50f7f libxpc.dylib (*) <8346be50-de08-3606-9fb6-9a352975661d> /usr/lib/system/libxpc.dylib

External Modification Summary:
  Calls made by other processes targeting this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by this process:
    task_for_pid: 0
    thread_create: 0
    thread_set_state: 0
  Calls made by all processes on this machine:
    task_for_pid: 63
    thread_create: 0
    thread_set_state: 4480

-----------
Full Report
-----------

{"app_name":"LocalDictation","timestamp":"2025-11-07 13:39:13.00 -0600","app_version":"1.0","slice_uuid":"fe444e5f-c0d0-36ed-b56e-235d4b762245","build_version":"1","platform":1,"bundleID":"com.yourname.LocalDictation","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.1 (25B78)","roots_installed":0,"name":"LocalDictation","incident_id":"DCA58AF7-1D3F-4C62-A2C1-163A65EA2E2D"}
{
  "uptime" : 100000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac16,12",
  "coalitionID" : 32341,
  "osVersion" : {
    "train" : "macOS 26.1",
    "build" : "25B78",
    "releaseType" : "User"
  },
  "captureTime" : "2025-11-07 13:39:10.3483 -0600",
  "codeSigningMonitor" : 2,
  "incident" : "DCA58AF7-1D3F-4C62-A2C1-163A65EA2E2D",
  "pid" : 19893,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-11-07 13:37:52.6045 -0600",
  "procStartAbsTime" : 2405044114394,
  "procExitAbsTime" : 2406905694420,
  "procName" : "LocalDictation",
  "procPath" : "\/Users\/USER\/*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
  "bundleInfo" : {"CFBundleShortVersionString":"1.0","CFBundleVersion":"1","CFBundleIdentifier":"com.yourname.LocalDictation"},
  "storeInfo" : {"deviceIdentifierForVendor":"A3BD9721-7479-5497-9472-92D4BCF93192","thirdParty":true},
  "parentProc" : "zsh",
  "parentPid" : 99712,
  "coalitionName" : "com.todesktop.230313mzl4w4u92",
  "crashReporterKey" : "C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2",
  "appleIntelligenceStatus" : {"state":"available"},
  "developerMode" : 1,
  "responsiblePid" : 68434,
  "responsibleProc" : "Cursor",
  "codeSigningID" : "com.yourname.LocalDictation",
  "codeSigningTeamID" : "",
  "codeSigningFlags" : 570503957,
  "codeSigningValidationCategory" : 10,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"ARAA1MADX9aQBYCSARAA1MADX9awBYCSARAA1MADX9bQBYCSARAA1A==","atPC":"wANf1vAFgJIBEADUwANf1hAGgJIBEADUwANf1jAGgJIBEADUwANf1g=="},
  "bootSessionUUID" : "8C7A2380-7264-4158-8047-64B17EB94963",
  "wakeTime" : 17648,
  "sleepWakeUUID" : "DD9B40A7-79AE-495C-B972-70C6C7761451",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000000, 0x0000000000000000","rawCodes":[0,0],"type":"EXC_CRASH","signal":"SIGABRT"},
  "termination" : {"flags":0,"code":6,"namespace":"SIGNAL","indicator":"Abort trap: 6","byProc":"LocalDictation","byPid":19893},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":4480,"task_for_pid":63},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":10524897,"threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":31898722107392},{"value":0},{"value":31898722107392},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":7427},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":31898722107392},{"value":0},{"value":31898722107392},{"value":6168302424},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6168302272},"sp":{"value":6168302192},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":4},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":4},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":4},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":792424,"symbol":"RunCurrentEventLoopInMode","symbolLocation":316,"imageIndex":6},{"imageOffset":805520,"symbol":"ReceiveNextEventCommon","symbolLocation":488,"imageIndex":6},{"imageOffset":2417416,"symbol":"_BlockUntilNextEventMatchingListInMode","symbolLocation":48,"imageIndex":6},{"imageOffset":5399488,"symbol":"_DPSBlockUntilNextEventMatchingListInMode","symbolLocation":236,"imageIndex":7},{"imageOffset":130612,"symbol":"_DPSNextEvent","symbolLocation":588,"imageIndex":7},{"imageOffset":11460420,"symbol":"-[NSApplication(NSEventRouting) _nextEventMatchingEventMask:untilDate:inMode:dequeue:]","symbolLocation":688,"imageIndex":7},{"imageOffset":11459664,"symbol":"-[NSApplication(NSEventRouting) nextEventMatchingMask:untilDate:inMode:dequeue:]","symbolLocation":72,"imageIndex":7},{"imageOffset":100224,"symbol":"-[NSApplication run]","symbolLocation":368,"imageIndex":7},{"imageOffset":18140,"symbol":"NSApplicationMain","symbolLocation":880,"imageIndex":7},{"imageOffset":1118480,"symbol":"specialized runApp(_:)","symbolLocation":168,"imageIndex":8},{"imageOffset":5022384,"symbol":"runApp<A>(_:)","symbolLocation":112,"imageIndex":8},{"imageOffset":7945556,"symbol":"static App.main()","symbolLocation":224,"imageIndex":8},{"imageOffset":387532,"sourceFile":"\/<compiler-generated>","symbol":"static LocalDictationApp.$main()","symbolLocation":40,"imageIndex":0},{"imageOffset":388152,"sourceFile":"LocalDictationApp.swift","symbol":"main","symbolLocation":12,"imageIndex":0},{"imageOffset":36180,"symbol":"start","symbolLocation":7184,"imageIndex":9}]},{"id":10524908,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":101167954657280},{"value":0},{"value":101167954657280},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23555},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":101167954657280},{"value":0},{"value":101167954657280},{"value":6170583176},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6170583024},"sp":{"value":6170582944},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":4},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":4},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":4},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":720052,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":7},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":11},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":11}]},{"id":10524931,"name":"caulk.messenger.shared:17","threadState":{"x":[{"value":14},{"value":25501368986},{"value":0},{"value":6171160682},{"value":25501368960},{"value":25},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50443334144},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6171160448},"sp":{"value":6171160416},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":12},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":12},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":11},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":11}]},{"id":10524932,"name":"caulk.messenger.shared:high","threadState":{"x":[{"value":14},{"value":40707},{"value":40707},{"value":15},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":1},{"value":50455940056},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50443334368},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6171733888},"sp":{"value":6171733856},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":12},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":12},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":11},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":11}]},{"id":10525263,"name":"com.apple.audio.toolbox.AUScheduledParameterRefresher","threadState":{"x":[{"value":14},{"value":25501420726},{"value":0},{"value":6172881030},{"value":25501420672},{"value":53},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50443487480},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6172880768},"sp":{"value":6172880736},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":12},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":12},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":11},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":11}]},{"id":10525264,"name":"caulk::deferred_logger","threadState":{"x":[{"value":14},{"value":50442895575},{"value":0},{"value":6173454439},{"value":50442895552},{"value":22},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50443487704},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6173454208},"sp":{"value":6173454176},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":4},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":12},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":12},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":11},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":11}]},{"id":10538038,"frames":[],"threadState":{"x":[{"value":6172307456},{"value":144179},{"value":6171770880},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6172307456},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10538039,"threadState":{"x":[{"value":6174022648},{"value":6174022808},{"value":0},{"value":768},{"value":6174022800},{"value":3},{"value":34359738371},{"value":3},{"value":0},{"value":28274239486080},{"value":2092},{"value":4503599627370495},{"value":4},{"value":50457032944},{"value":8366674184,"symbolLocation":0,"symbol":"OBJC_CLASS_$___NSTaggedDate"},{"value":8366674184,"symbolLocation":0,"symbol":"OBJC_CLASS_$___NSTaggedDate"},{"value":8393596528,"symbolLocation":16,"symbol":"vtable for icu::UnicodeString"},{"value":11153727433310477304},{"value":0},{"value":6174022648},{"value":768},{"value":6174022808},{"value":0},{"value":50455559040},{"value":0},{"value":8262492752,"symbolLocation":0,"symbol":"kCFAllocatorSystemDefault"},{"value":4429218752},{"value":0},{"value":276}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6610431320},"cpsr":{"value":2147483648},"fp":{"value":6174022592},"sp":{"value":6174022560},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6608884728},"far":{"value":0}},"queue":"com.LocalDictation.DebugLogger","frames":[{"imageOffset":754680,"symbol":"icu::UnicodeString::setTo(char16_t*, int, int)","symbolLocation":268,"imageIndex":13},{"imageOffset":2301272,"symbol":"udat_format","symbolLocation":172,"imageIndex":13},{"imageOffset":560704,"symbol":"CFDateFormatterCreateStringWithAbsoluteTime","symbolLocation":192,"imageIndex":5},{"imageOffset":10026324,"symbol":"-[NSDateFormatter stringForObjectValue:]","symbolLocation":292,"imageIndex":14},{"imageOffset":91340,"sourceLine":77,"sourceFile":"DebugLogger.swift","symbol":"closure #1 in DebugLogger.log(_:file:function:line:level:)","imageIndex":0,"symbolLocation":660},{"imageOffset":93696,"sourceFile":"\/<compiler-generated>","symbol":"partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:)","symbolLocation":60,"imageIndex":0},{"imageOffset":94100,"sourceFile":"\/<compiler-generated>","symbol":"thunk for @escaping @callee_guaranteed @Sendable () -> ()","symbolLocation":48,"imageIndex":0},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":15},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":15},{"imageOffset":42216,"symbol":"_dispatch_lane_serial_drain","symbolLocation":740,"imageIndex":15},{"imageOffset":44996,"symbol":"_dispatch_lane_invoke","symbolLocation":388,"imageIndex":15},{"imageOffset":87156,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":292,"imageIndex":15},{"imageOffset":85356,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":15},{"imageOffset":11852,"symbol":"_pthread_wqthread","symbolLocation":292,"imageIndex":11},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":11}]},{"id":10538040,"frames":[],"threadState":{"x":[{"value":6174601216},{"value":4647},{"value":6174064640},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6174601216},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10539556,"threadState":{"x":[{"value":0},{"value":0},{"value":0},{"value":50433606600},{"value":36},{"value":50433606652},{"value":512},{"value":0},{"value":32},{"value":8366594856,"symbolLocation":0,"symbol":"_current_pid"},{"value":72057598332895232},{"value":10539556},{"value":489262402148569092},{"value":144115192639259056},{"value":2199023259648},{"value":144115188344291456},{"value":520},{"value":8389596384},{"value":0},{"value":0},{"value":50433606652},{"value":36},{"value":50433606600},{"value":0},{"value":11},{"value":50444444992},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544270288},"cpsr":{"value":0},"fp":{"value":6168864272},"sp":{"value":6168864208},"esr":{"value":4060086273,"description":"(Breakpoint) brk 1"},"pc":{"value":6544270288},"far":{"value":0}},"queue":"com.apple.root.default-qos","frames":[{"imageOffset":213968,"symbol":"abort_with_payload_wrapper_internal","symbolLocation":136,"imageIndex":4},{"imageOffset":213988,"symbol":"abort_with_payload","symbolLocation":16,"imageIndex":4},{"imageOffset":20116,"symbol":"__TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION__","symbolLocation":172,"imageIndex":16},{"imageOffset":22496,"symbol":"__TCCAccessRequest_block_invoke.229","symbolLocation":628,"imageIndex":16},{"imageOffset":10284,"symbol":"__tccd_send_message_block_invoke","symbolLocation":632,"imageIndex":16},{"imageOffset":65140,"symbol":"_xpc_connection_reply_callout","symbolLocation":124,"imageIndex":17},{"imageOffset":64872,"symbol":"_xpc_connection_call_reply_async","symbolLocation":96,"imageIndex":17},{"imageOffset":113396,"symbol":"<deduplicated_symbol>","symbolLocation":16,"imageIndex":15},{"imageOffset":129768,"symbol":"_dispatch_mach_msg_async_reply_invoke","symbolLocation":340,"imageIndex":15},{"imageOffset":86396,"symbol":"_dispatch_root_queue_drain_deferred_item","symbolLocation":216,"imageIndex":15},{"imageOffset":84452,"symbol":"_dispatch_kevent_worker_thread","symbolLocation":520,"imageIndex":15},{"imageOffset":11908,"symbol":"_pthread_wqthread","symbolLocation":348,"imageIndex":11},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":11}]},{"id":10540295,"frames":[],"threadState":{"x":[{"value":6175174656},{"value":158995},{"value":6174638080},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6175174656},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10540296,"frames":[],"threadState":{"x":[{"value":6175748096},{"value":141619},{"value":6175211520},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6175748096},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10540297,"frames":[],"threadState":{"x":[{"value":6176321536},{"value":103379},{"value":6175784960},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6176321536},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10540298,"frames":[],"threadState":{"x":[{"value":6176894976},{"value":112035},{"value":6176358400},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6176894976},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10541647,"frames":[],"threadState":{"x":[{"value":6169440256},{"value":158051},{"value":6168903680},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6169440256},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10541648,"frames":[],"threadState":{"x":[{"value":6170013696},{"value":0},{"value":6169477120},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6170013696},"esr":{"value":0},"pc":{"value":6544313236},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4298571776,
    "size" : 770048,
    "uuid" : "fe444e5f-c0d0-36ed-b56e-235d4b762245",
    "path" : "*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
    "name" : "LocalDictation"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4530044928,
    "CFBundleShortVersionString" : "1.14",
    "CFBundleIdentifier" : "com.apple.audio.units.Components",
    "size" : 1327104,
    "uuid" : "9155d5f9-804c-3e9b-a2d9-b4ccff316f05",
    "path" : "\/System\/Library\/Components\/CoreAudio.component\/Contents\/MacOS\/CoreAudio",
    "name" : "CoreAudio",
    "CFBundleVersion" : "1.14"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4527390720,
    "size" : 49152,
    "uuid" : "f8bd9069-8c4f-37ea-af9a-2b1060f54e4f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4726341632,
    "CFBundleShortVersionString" : "341.11",
    "CFBundleIdentifier" : "com.apple.AGXMetalG16G-B0",
    "size" : 8552448,
    "uuid" : "a22549f3-d4f5-3b88-af18-e06837f0d352",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG16G_B0.bundle\/Contents\/MacOS\/AGXMetalG16G_B0",
    "name" : "AGXMetalG16G_B0",
    "CFBundleVersion" : "341.11"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6544056320,
    "size" : 246944,
    "uuid" : "9fe7c84d-0c2b-363f-bee5-6fd76d67a227",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6544592896,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.CoreFoundation",
    "size" : 5532352,
    "uuid" : "3c4a3add-9e48-33da-82ee-80520e6cbe3b",
    "path" : "\/System\/Library\/Frameworks\/CoreFoundation.framework\/Versions\/A\/CoreFoundation",
    "name" : "CoreFoundation",
    "CFBundleVersion" : "4109.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6756773888,
    "CFBundleShortVersionString" : "2.1.1",
    "CFBundleIdentifier" : "com.apple.HIToolbox",
    "size" : 3155968,
    "uuid" : "9ab64c08-0685-3a0d-9a7e-83e7a1e9ebb4",
    "path" : "\/System\/Library\/Frameworks\/Carbon.framework\/Versions\/A\/Frameworks\/HIToolbox.framework\/Versions\/A\/HIToolbox",
    "name" : "HIToolbox"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6616195072,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.AppKit",
    "size" : 24300448,
    "uuid" : "3c0949bb-e361-369a-80b7-17440eb09e98",
    "path" : "\/System\/Library\/Frameworks\/AppKit.framework\/Versions\/C\/AppKit",
    "name" : "AppKit",
    "CFBundleVersion" : "2685.20.119"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 7411666944,
    "CFBundleShortVersionString" : "7.1.13.1.401",
    "CFBundleIdentifier" : "com.apple.SwiftUI",
    "size" : 24376768,
    "uuid" : "6a83fd25-8f6d-3773-9285-cea41ce49fb5",
    "path" : "\/System\/Library\/Frameworks\/SwiftUI.framework\/Versions\/A\/SwiftUI",
    "name" : "SwiftUI",
    "CFBundleVersion" : "7.1.13.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6540333056,
    "size" : 651108,
    "uuid" : "b50f5a1a-be81-3068-92e1-3554f2be478a",
    "path" : "\/usr\/lib\/dyld",
    "name" : "dyld"
  },
  {
    "size" : 0,
    "source" : "A",
    "base" : 0,
    "uuid" : "00000000-0000-0000-0000-000000000000"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6544306176,
    "size" : 51900,
    "uuid" : "e95973b8-824c-361e-adf4-390747c40897",
    "path" : "\/usr\/lib\/system\/libsystem_pthread.dylib",
    "name" : "libsystem_pthread.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6751830016,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.audio.caulk",
    "size" : 167296,
    "uuid" : "9c791aec-e0d3-3ace-ac9e-e7a4d59b7762",
    "path" : "\/System\/Library\/PrivateFrameworks\/caulk.framework\/Versions\/A\/caulk",
    "name" : "caulk"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6608130048,
    "size" : 2955290,
    "uuid" : "ec990bc7-956f-300a-8870-118269cb7e73",
    "path" : "\/usr\/lib\/libicucore.A.dylib",
    "name" : "libicucore.A.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6570061824,
    "CFBundleShortVersionString" : "6.9",
    "CFBundleIdentifier" : "com.apple.Foundation",
    "size" : 16396896,
    "uuid" : "00467f1f-216a-36fe-8587-c820c7e0437d",
    "path" : "\/System\/Library\/Frameworks\/Foundation.framework\/Versions\/C\/Foundation",
    "name" : "Foundation",
    "CFBundleVersion" : "4109.1.401"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6542503936,
    "size" : 290464,
    "uuid" : "8fb392ae-401f-399a-96ae-41531cf91162",
    "path" : "\/usr\/lib\/system\/libdispatch.dylib",
    "name" : "libdispatch.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6653022208,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.TCC",
    "size" : 150500,
    "uuid" : "bf63fec0-56e5-37ba-b7d4-629ea4c8114a",
    "path" : "\/System\/Library\/PrivateFrameworks\/TCC.framework\/Versions\/A\/TCC",
    "name" : "TCC",
    "CFBundleVersion" : "1"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6541000704,
    "size" : 348032,
    "uuid" : "8346be50-de08-3606-9fb6-9a352975661d",
    "path" : "\/usr\/lib\/system\/libxpc.dylib",
    "name" : "libxpc.dylib"
  }
],
  "sharedCache" : {
  "base" : 6539247616,
  "size" : 5609635840,
  "uuid" : "b69ff43c-dbfd-3fb1-b4fe-a8fe32ea1062"
},
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "28a4dfbfc336b8f95a413abf335c8402248409bb",
  "trialInfo" : {
  "rollouts" : [
    {
      "rolloutId" : "64628732bf2f5257dedc8988",
      "factorPackIds" : [

      ],
      "deploymentId" : 240000001
    },
    {
      "rolloutId" : "68095e8ecb2a9d1eaa8463c9",
      "factorPackIds" : [
        "68bf4eacb556ea03e19aed49"
      ],
      "deploymentId" : 240000008
    }
  ],
  "experiments" : [

  ]
}
}

Model: Mac16,12, BootROM 13822.41.1, proc 10:4:6 processors, 24 GB, SMC 
Graphics: Apple M4, Apple M4, Built-In
Display: ASUS PB287Q, 6016 x 3384, Main, MirrorOff, Online
Display: Color LCD, 2560 x 1664 Retina, MirrorOff, Online
Display: VA24D, 1920 x 1080 (1080p FHD - Full High Definition), MirrorOff, Online
Memory Module: LPDDR5, Micron
AirPort: spairport_wireless_card_type_wifi (0x14E4, 0x4388), wl0: Oct  3 2025 00:48:50 version 23.41.7.0.41.51.200 FWID 01-8b09c4e0
IO80211_driverkit-1530.16 "IO80211_driverkit-1530.16" Oct 10 2025 22:56:35
AirPort: 
Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
Network Service: Wi-Fi, AirPort, en0
PCI Card: pci8086,15f0, USB eXtensible Host Controller, Thunderbolt@3,0,0
Thunderbolt Bus: MacBook Air, Apple Inc.
Thunderbolt Device: VT4800, VisionTek, 1, 64.1
Thunderbolt Bus: MacBook Air, Apple Inc.
