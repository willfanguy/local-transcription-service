-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             LocalDictation [49800]
Path:                /Users/USER/*/LocalDictation.app/Contents/MacOS/LocalDictation
Identifier:          com.yourname.LocalDictation
Version:             1.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      zsh [99712]
Coalition:           com.todesktop.230313mzl4w4u92 [32341]
Responsible Process: Cursor [68434]
User ID:             501

Date/Time:           2025-11-07 13:44:03.6701 -0600
Launch Time:         2025-11-07 13:43:51.9497 -0600
Hardware Model:      Mac16,12
OS Version:          macOS 26.1 (25B78)
Release Type:        User

Crash Reporter Key:  C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2
Incident Identifier: 1516D1CF-8BF1-4E99-AD4F-35CFAFD92AA6

Sleep/Wake UUID:       DD9B40A7-79AE-495C-B972-70C6C7761451

Time Awake Since Boot: 100000 seconds
Time Since Wake:       17941 seconds

System Integrity Protection: enabled

Triggered by Thread: 9, Dispatch Queue: com.apple.root.default-qos

Exception Type:    EXC_CRASH (SIGKILL)
Exception Codes:   0x0000000000000000, 0x0000000000000000

Termination Reason:  Namespace TCC, Code 0, 
This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSSpeechRecognitionUsageDescription key with a string value explaining to the user how the app uses this data.


Thread 0:

Thread 1:

Thread 2:: com.apple.NSEventThread
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

Thread 3:: caulk.messenger.shared:17
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 4:: caulk.messenger.shared:high
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 5:: com.apple.audio.toolbox.AUScheduledParameterRefresher
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 6:: caulk::deferred_logger
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 7::  Dispatch queue: com.LocalDictation.DebugLogger
0   libsystem_kernel.dylib        	       0x1860f283c lstat + 8
1   Foundation                    	       0x188106fe4 _SwiftURL.init(filePath:pathStyle:directoryHint:relativeTo:) + 5020
2   Foundation                    	       0x18810ea1c specialized _SwiftURL.__allocating_init(fileURLWithPath:) + 200
3   Foundation                    	       0x1880c813c URL.init(fileURLWithPath:) + 172
4   LocalDictation                	       0x100352538 closure #1 in DebugLogger.log(_:file:function:line:level:) + 768 (DebugLogger.swift:78)
5   LocalDictation                	       0x100352e00 partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:) + 60
6   LocalDictation                	       0x100352f94 thunk for @escaping @callee_guaranteed @Sendable () -> () + 48
7   libdispatch.dylib             	       0x185f6cb5c _dispatch_call_block_and_release + 32
8   libdispatch.dylib             	       0x185f86ac4 _dispatch_client_callout + 16
9   libdispatch.dylib             	       0x185f754e8 _dispatch_lane_serial_drain + 740
10  libdispatch.dylib             	       0x185f75fc4 _dispatch_lane_invoke + 388
11  libdispatch.dylib             	       0x185f80474 _dispatch_root_queue_drain_deferred_wlh + 292
12  libdispatch.dylib             	       0x185f7fd6c _dispatch_workloop_worker_thread + 692
13  libsystem_pthread.dylib       	       0x186125e4c _pthread_wqthread + 292
14  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 8:

Thread 9 Crashed::  Dispatch queue: com.apple.root.default-qos
0   libsystem_kernel.dylib        	       0x1860f15d4 __terminate_with_payload + 8
1   libsystem_kernel.dylib        	       0x18611a3d0 abort_with_payload_wrapper_internal + 136
2   libsystem_kernel.dylib        	       0x18611a3e4 abort_with_payload + 16
3   TCC                           	       0x18c8d5e94 __TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION__ + 172
4   TCC                           	       0x18c8d67e0 __TCCAccessRequest_block_invoke.229 + 628
5   TCC                           	       0x18c8d382c __tccd_send_message_block_invoke + 632
6   libxpc.dylib                  	       0x185e0be74 _xpc_connection_reply_callout + 124
7   libxpc.dylib                  	       0x185e0bd68 _xpc_connection_call_reply_async + 96
8   libdispatch.dylib             	       0x185f86af4 <deduplicated_symbol> + 16
9   libdispatch.dylib             	       0x185f8aae8 _dispatch_mach_msg_async_reply_invoke + 340
10  libdispatch.dylib             	       0x185f8017c _dispatch_root_queue_drain_deferred_item + 216
11  libdispatch.dylib             	       0x185f7f9e4 _dispatch_kevent_worker_thread + 520
12  libsystem_pthread.dylib       	       0x186125e84 _pthread_wqthread + 348
13  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 10:

Thread 11:

Thread 12:

Thread 13:


Thread 9 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x000000093076d2c8
    x4: 0x0000000000000024   x5: 0x000000093076d2fc   x6: 0x0000000000000200   x7: 0x0000000000000000
    x8: 0x0000000000000020   x9: 0x00000001f2b01b28  x10: 0x0100000100000000  x11: 0x0000000000a1c8bc
   x12: 0x06ca359002051004  x13: 0x0200000110000cf0  x14: 0x0000020000001000  x15: 0x0200000010000bc0
   x16: 0x0000000000000208  x17: 0x00000001f40f14e0  x18: 0x0000000000000000  x19: 0x0000000000000000
   x20: 0x000000093076d2fc  x21: 0x0000000000000024  x22: 0x000000093076d2c8  x23: 0x0000000000000000
   x24: 0x000000000000000b  x25: 0x0000000932c165c0  x26: 0x0000000000000000  x27: 0x0000000000000000
   x28: 0x0000000000000000   fp: 0x00000001702f2610   lr: 0x000000018611a3d0
    sp: 0x00000001702f25d0   pc: 0x00000001860f15d4 cpsr: 0x00000000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x10033c000 -        0x1003f7fff LocalDictation (*) <979c4971-bf4b-35da-a64d-aec7c490427d> */LocalDictation.app/Contents/MacOS/LocalDictation
       0x10e054000 -        0x10e197fff com.apple.audio.units.Components (1.14) <9155d5f9-804c-3e9b-a2d9-b4ccff316f05> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
       0x10ddd0000 -        0x10dddbfff libobjc-trampolines.dylib (*) <f8bd9069-8c4f-37ea-af9a-2b1060f54e4f> /usr/lib/libobjc-trampolines.dylib
       0x119b88000 -        0x11a3affff com.apple.AGXMetalG16G-B0 (341.11) <a22549f3-d4f5-3b88-af18-e06837f0d352> /System/Library/Extensions/AGXMetalG16G_B0.bundle/Contents/MacOS/AGXMetalG16G_B0
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x1860e6000 -        0x18612249f libsystem_kernel.dylib (*) <9fe7c84d-0c2b-363f-bee5-6fd76d67a227> /usr/lib/system/libsystem_kernel.dylib
       0x186169000 -        0x1866afabf com.apple.CoreFoundation (6.9) <3c4a3add-9e48-33da-82ee-80520e6cbe3b> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x18a5b2000 -        0x18bcdeb9f com.apple.AppKit (6.9) <3c0949bb-e361-369a-80b7-17440eb09e98> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x186123000 -        0x18612fabb libsystem_pthread.dylib (*) <e95973b8-824c-361e-adf4-390747c40897> /usr/lib/system/libsystem_pthread.dylib
       0x19270c000 -        0x192734d7f com.apple.audio.caulk (1.0) <9c791aec-e0d3-3ace-ac9e-e7a4d59b7762> /System/Library/PrivateFrameworks/caulk.framework/Versions/A/caulk
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

{"app_name":"LocalDictation","timestamp":"2025-11-07 13:44:06.00 -0600","app_version":"1.0","slice_uuid":"979c4971-bf4b-35da-a64d-aec7c490427d","build_version":"1","platform":1,"bundleID":"com.yourname.LocalDictation","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.1 (25B78)","roots_installed":0,"name":"LocalDictation","incident_id":"1516D1CF-8BF1-4E99-AD4F-35CFAFD92AA6"}
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
  "captureTime" : "2025-11-07 13:44:03.6701 -0600",
  "codeSigningMonitor" : 2,
  "incident" : "1516D1CF-8BF1-4E99-AD4F-35CFAFD92AA6",
  "pid" : 49800,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-11-07 13:43:51.9497 -0600",
  "procStartAbsTime" : 2413667800392,
  "procExitAbsTime" : 2413948638125,
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
  "instructionByteStream" : {"beforePC":"FgCAUncCALne\/\/8X5gMEquUDA6oDAIDSBACAUgEAABQQQYDSARAA1A==","atPC":"AwEAVH8jA9X9e7+p\/QMAkQDY\/5e\/AwCR\/XvBqP8PX9bAA1\/WfyMD1Q=="},
  "bootSessionUUID" : "8C7A2380-7264-4158-8047-64B17EB94963",
  "wakeTime" : 17941,
  "sleepWakeUUID" : "DD9B40A7-79AE-495C-B972-70C6C7761451",
  "sip" : "enabled",
  "exception" : {"codes":"0x0000000000000000, 0x0000000000000000","rawCodes":[0,0],"type":"EXC_CRASH","signal":"SIGKILL"},
  "termination" : {"flags":518,"code":0,"namespace":"TCC","details":["This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSSpeechRecognitionUsageDescription key with a string value explaining to the user how the app uses this data."]},
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":4480,"task_for_pid":63},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 9,
  "threads" : [{"id":10602480,"frames":[],"threadState":{"x":[{"value":6169079808},{"value":4355},{"value":6168543232},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6169079808},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10602487,"frames":[],"threadState":{"x":[{"value":6170226688},{"value":18691},{"value":6169690112},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6170226688},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10602488,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":0},{"value":21592279046},{"value":8589934592},{"value":127556233723904},{"value":0},{"value":127556233723904},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":29699},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":127556233723904},{"value":0},{"value":127556233723904},{"value":6170796168},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6170796016},"sp":{"value":6170795936},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":5},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":5},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":5},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":5},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":6},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":6},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":6},{"imageOffset":720052,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":7},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":8},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":8}]},{"id":10602626,"name":"caulk.messenger.shared:17","threadState":{"x":[{"value":14},{"value":21206401690},{"value":0},{"value":6171947114},{"value":21206401664},{"value":25},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":39469580320},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6171946880},"sp":{"value":6171946848},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":5},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":9},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":9},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":9},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":8},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":8}]},{"id":10602627,"name":"caulk.messenger.shared:high","threadState":{"x":[{"value":14},{"value":41475},{"value":41475},{"value":15},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":1},{"value":39481041880},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":39469582336},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6172520320},"sp":{"value":6172520288},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":5},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":9},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":9},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":9},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":8},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":8}]},{"id":10602663,"name":"com.apple.audio.toolbox.AUScheduledParameterRefresher","threadState":{"x":[{"value":14},{"value":21206453430},{"value":0},{"value":6173667462},{"value":21206453376},{"value":53},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":39471611960},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6173667200},"sp":{"value":6173667168},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":5},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":9},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":9},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":9},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":8},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":8}]},{"id":10602664,"name":"caulk::deferred_logger","threadState":{"x":[{"value":14},{"value":39482835447},{"value":0},{"value":6174240871},{"value":39482835424},{"value":22},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":39471612184},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6174240640},"sp":{"value":6174240608},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":5},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":9},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":9},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":9},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":8},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":8}]},{"id":10602681,"threadState":{"x":[{"value":0},{"value":0},{"value":265},{"value":1},{"value":39477091072},{"value":88},{"value":18446744072631617535},{"value":18446726482597246976},{"value":6175384192},{"value":17179869187},{"value":8589934595},{"value":6175383472},{"value":39477091160},{"value":14905534884541077868},{"value":116},{"value":39465304064},{"value":340},{"value":8389597768},{"value":0},{"value":39472701088},{"value":39477091040},{"value":6175383600},{"value":17293822569102704728},{"value":6175383936},{"value":6175383872},{"value":1},{"value":17293822569102704728},{"value":39477091040},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6577745892},"cpsr":{"value":1073741824},"fp":{"value":6175384208},"sp":{"value":6175383600},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544107580},"far":{"value":0}},"queue":"com.LocalDictation.DebugLogger","frames":[{"imageOffset":51260,"symbol":"lstat","symbolLocation":8,"imageIndex":5},{"imageOffset":7684068,"symbol":"_SwiftURL.init(filePath:pathStyle:directoryHint:relativeTo:)","symbolLocation":5020,"imageIndex":10},{"imageOffset":7715356,"symbol":"specialized _SwiftURL.__allocating_init(fileURLWithPath:)","symbolLocation":200,"imageIndex":10},{"imageOffset":7426364,"symbol":"URL.init(fileURLWithPath:)","symbolLocation":172,"imageIndex":10},{"imageOffset":91448,"sourceLine":78,"sourceFile":"DebugLogger.swift","symbol":"closure #1 in DebugLogger.log(_:file:function:line:level:)","imageIndex":0,"symbolLocation":768},{"imageOffset":93696,"sourceFile":"\/<compiler-generated>","symbol":"partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:)","symbolLocation":60,"imageIndex":0},{"imageOffset":94100,"sourceFile":"\/<compiler-generated>","symbol":"thunk for @escaping @callee_guaranteed @Sendable () -> ()","symbolLocation":48,"imageIndex":0},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":11},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":11},{"imageOffset":42216,"symbol":"_dispatch_lane_serial_drain","symbolLocation":740,"imageIndex":11},{"imageOffset":44996,"symbol":"_dispatch_lane_invoke","symbolLocation":388,"imageIndex":11},{"imageOffset":87156,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":292,"imageIndex":11},{"imageOffset":85356,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":11},{"imageOffset":11852,"symbol":"_pthread_wqthread","symbolLocation":292,"imageIndex":8},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":8}]},{"id":10602683,"frames":[],"threadState":{"x":[{"value":6176534528},{"value":115779},{"value":6175997952},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6176534528},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"triggered":true,"id":10602684,"threadState":{"x":[{"value":0},{"value":0},{"value":0},{"value":39467799240},{"value":36},{"value":39467799292},{"value":512},{"value":0},{"value":32},{"value":8366594856,"symbolLocation":0,"symbol":"_current_pid"},{"value":72057598332895232},{"value":10602684},{"value":489262402148569092},{"value":144115192639261936},{"value":2199023259648},{"value":144115188344294336},{"value":520},{"value":8389596384},{"value":0},{"value":0},{"value":39467799292},{"value":36},{"value":39467799240},{"value":0},{"value":11},{"value":39506240960},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544270288},"cpsr":{"value":0},"fp":{"value":6177105424},"sp":{"value":6177105360},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544102868,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.root.default-qos","frames":[{"imageOffset":46548,"symbol":"__terminate_with_payload","symbolLocation":8,"imageIndex":5},{"imageOffset":213968,"symbol":"abort_with_payload_wrapper_internal","symbolLocation":136,"imageIndex":5},{"imageOffset":213988,"symbol":"abort_with_payload","symbolLocation":16,"imageIndex":5},{"imageOffset":20116,"symbol":"__TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION__","symbolLocation":172,"imageIndex":12},{"imageOffset":22496,"symbol":"__TCCAccessRequest_block_invoke.229","symbolLocation":628,"imageIndex":12},{"imageOffset":10284,"symbol":"__tccd_send_message_block_invoke","symbolLocation":632,"imageIndex":12},{"imageOffset":65140,"symbol":"_xpc_connection_reply_callout","symbolLocation":124,"imageIndex":13},{"imageOffset":64872,"symbol":"_xpc_connection_call_reply_async","symbolLocation":96,"imageIndex":13},{"imageOffset":113396,"symbol":"<deduplicated_symbol>","symbolLocation":16,"imageIndex":11},{"imageOffset":129768,"symbol":"_dispatch_mach_msg_async_reply_invoke","symbolLocation":340,"imageIndex":11},{"imageOffset":86396,"symbol":"_dispatch_root_queue_drain_deferred_item","symbolLocation":216,"imageIndex":11},{"imageOffset":84452,"symbol":"_dispatch_kevent_worker_thread","symbolLocation":520,"imageIndex":11},{"imageOffset":11908,"symbol":"_pthread_wqthread","symbolLocation":348,"imageIndex":8},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":8}]},{"id":10604646,"frames":[],"threadState":{"x":[{"value":6169653248},{"value":174351},{"value":6169116672},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6169653248},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10604647,"frames":[],"threadState":{"x":[{"value":6171373568},{"value":113939},{"value":6170836992},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6171373568},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10604648,"frames":[],"threadState":{"x":[{"value":6173093888},{"value":108843},{"value":6172557312},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6173093888},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10604649,"frames":[],"threadState":{"x":[{"value":6174814208},{"value":0},{"value":6174277632},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6174814208},"esr":{"value":0},"pc":{"value":6544313236},"far":{"value":0}}}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4298358784,
    "size" : 770048,
    "uuid" : "979c4971-bf4b-35da-a64d-aec7c490427d",
    "path" : "*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
    "name" : "LocalDictation"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4530192384,
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
    "base" : 4527554560,
    "size" : 49152,
    "uuid" : "f8bd9069-8c4f-37ea-af9a-2b1060f54e4f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4726489088,
    "CFBundleShortVersionString" : "341.11",
    "CFBundleIdentifier" : "com.apple.AGXMetalG16G-B0",
    "size" : 8552448,
    "uuid" : "a22549f3-d4f5-3b88-af18-e06837f0d352",
    "path" : "\/System\/Library\/Extensions\/AGXMetalG16G_B0.bundle\/Contents\/MacOS\/AGXMetalG16G_B0",
    "name" : "AGXMetalG16G_B0",
    "CFBundleVersion" : "341.11"
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
    "queue" : "com.apple.root.default-qos"
  }
},
  "logWritingSignature" : "fe576adf87c47ff1055fcf20a50bc007bd98adf8",
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
