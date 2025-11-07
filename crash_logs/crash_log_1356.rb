-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             LocalDictation [24217]
Path:                /Users/USER/*/LocalDictation.app/Contents/MacOS/LocalDictation
Identifier:          com.yourname.LocalDictation
Version:             1.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      Exited process [24204]
Coalition:           com.googlecode.iterm2 [1137]
Responsible Process: iTerm2 [1392]
User ID:             501

Date/Time:           2025-11-07 13:55:42.6209 -0600
Launch Time:         2025-11-07 13:55:14.0002 -0600
Hardware Model:      Mac16,12
OS Version:          macOS 26.1 (25B78)
Release Type:        User

Crash Reporter Key:  C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2
Incident Identifier: C0CC43BE-9805-4CCD-BC61-92A7B85B218F

Sleep/Wake UUID:       DD9B40A7-79AE-495C-B972-70C6C7761451

Time Awake Since Boot: 100000 seconds
Time Since Wake:       18640 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x000065a203bb2838
Exception Codes:   0x0000000000000001, 0x000065a203bb2838


VM Region Info: 0x65a203bb2838 is not in any region.  
      REGION TYPE                    START - END         [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
      UNUSED SPACE AT START
--->  
      UNUSED SPACE AT END

Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   libobjc.A.dylib               	       0x185cdc120 objc_release + 16
1   libobjc.A.dylib               	       0x185ce3c84 AutoreleasePoolPage::releaseUntil(objc_object**) + 204
2   libobjc.A.dylib               	       0x185ce0150 objc_autoreleasePoolPop + 244
3   CoreFoundation                	       0x18619a684 _CFAutoreleasePoolPop + 32
4   Foundation                    	       0x1879cb114 -[NSAutoreleasePool drain] + 136
5   AppKit                        	       0x18a5ca7b0 -[NSApplication run] + 416
6   AppKit                        	       0x18a5b66dc NSApplicationMain + 880
7   SwiftUI                       	       0x1b9d62110 specialized runApp(_:) + 168
8   SwiftUI                       	       0x1ba11b2b0 runApp<A>(_:) + 112
9   SwiftUI                       	       0x1ba3e4d54 static App.main() + 224
10  LocalDictation                	       0x1025330c4 static LocalDictationApp.$main() + 40
11  LocalDictation                	       0x102533330 main + 12
12  dyld                          	       0x185d61d54 start + 7184

Thread 1::  Dispatch queue: com.apple.root.user-interactive-qos
0   libsystem_kernel.dylib        	       0x1860e6c34 mach_msg2_trap + 8
1   libsystem_kernel.dylib        	       0x1860f9028 mach_msg2_internal + 76
2   libsystem_kernel.dylib        	       0x1860ef98c mach_msg_overwrite + 484
3   libsystem_kernel.dylib        	       0x1860e6fb4 mach_msg + 24
4   CoreFoundation                	       0x1861c8b90 __CFRunLoopServiceMachPort + 160
5   CoreFoundation                	       0x1861c74e8 __CFRunLoopRun + 1188
6   CoreFoundation                	       0x18628135c _CFRunLoopRunSpecificWithOptions + 532
7   Foundation                    	       0x18840e890 -[NSRunLoop(NSRunLoop) runMode:beforeDate:] + 212
8   AppKit                        	       0x18ab23454 -[NSAnimation _runBlocking] + 412
9   libdispatch.dylib             	       0x185f6cb5c _dispatch_call_block_and_release + 32
10  libdispatch.dylib             	       0x185f86ac4 _dispatch_client_callout + 16
11  libdispatch.dylib             	       0x185fa39ec <deduplicated_symbol> + 32
12  libdispatch.dylib             	       0x185f7f13c _dispatch_root_queue_drain + 736
13  libdispatch.dylib             	       0x185f7f784 _dispatch_worker_thread2 + 180
14  libsystem_pthread.dylib       	       0x186125e10 _pthread_wqthread + 232
15  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 2:

Thread 3:: com.apple.NSEventThread
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

Thread 4:: caulk.messenger.shared:17
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 5:: caulk.messenger.shared:high
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 6:: com.apple.audio.toolbox.AUScheduledParameterRefresher
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 7:: caulk::deferred_logger
0   libsystem_kernel.dylib        	       0x1860e6bb0 semaphore_wait_trap + 8
1   caulk                         	       0x19270de08 caulk::semaphore::timed_wait(double) + 224
2   caulk                         	       0x19270dcb0 caulk::concurrent::details::worker_thread::run() + 32
3   caulk                         	       0x19270d950 void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*) + 96
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 8::  Dispatch queue: com.LocalDictation.DebugLogger
0   libswiftCore.dylib            	       0x19968d87c _allocateStringStorage(codeUnitCapacity:) + 160
1   libswiftCore.dylib            	       0x1997a5e68 specialized static __StringStorage.create(initializingFrom:codeUnitCapacity:isASCII:) + 52
2   libswiftCore.dylib            	       0x1997a6224 specialized static String._uncheckedFromUTF8(_:isASCII:) + 40
3   libswiftCore.dylib            	       0x1997b34b8 String.init(cString:) + 72
4   Foundation                    	       0x18809a2cc specialized String.withFileSystemRepresentation<A>(_:) + 216
5   Foundation                    	       0x18810e9d0 specialized _SwiftURL.__allocating_init(fileURLWithPath:) + 124
6   Foundation                    	       0x1880c813c URL.init(fileURLWithPath:) + 172
7   LocalDictation                	       0x1024eaadc closure #1 in DebugLogger.log(_:file:function:line:level:) + 768 (DebugLogger.swift:78)
8   LocalDictation                	       0x1024eb3a4 partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:) + 60
9   LocalDictation                	       0x1024eb538 thunk for @escaping @callee_guaranteed @Sendable () -> () + 48
10  libdispatch.dylib             	       0x185f6cb5c _dispatch_call_block_and_release + 32
11  libdispatch.dylib             	       0x185f86ac4 _dispatch_client_callout + 16
12  libdispatch.dylib             	       0x185f754e8 _dispatch_lane_serial_drain + 740
13  libdispatch.dylib             	       0x185f75fc4 _dispatch_lane_invoke + 388
14  libdispatch.dylib             	       0x185f80474 _dispatch_root_queue_drain_deferred_wlh + 292
15  libdispatch.dylib             	       0x185f7fd6c _dispatch_workloop_worker_thread + 692
16  libsystem_pthread.dylib       	       0x186125e4c _pthread_wqthread + 292
17  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 9:

Thread 10:

Thread 11:

Thread 12:

Thread 13:

Thread 14:

Thread 15:

Thread 16:

Thread 17:: com.apple.audio.IOThread.client
0   libsystem_kernel.dylib        	       0x1860e6bbc semaphore_wait_signal_trap + 8
1   caulk                         	       0x19272afa8 caulk::mach::semaphore::wait_signal_or_error(caulk::mach::semaphore&) + 36
2   CoreAudio                     	       0x189436284 HALC_ProxyIOContext::IOWorkLoop() + 5052
3   CoreAudio                     	       0x189434820 invocation function for block in HALC_ProxyIOContext::HALC_ProxyIOContext(unsigned int, unsigned int) + 172
4   CoreAudio                     	       0x1896022c0 HALC_IOThread::Entry(void*) + 88
5   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
6   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

Thread 18:: AudioSession - RootQueue
0   libsystem_kernel.dylib        	       0x1860e6bc8 semaphore_timedwait_trap + 8
1   libdispatch.dylib             	       0x185fa1c84 _dispatch_sema4_timedwait + 64
2   libdispatch.dylib             	       0x185f6ef08 _dispatch_semaphore_wait_slow + 76
3   libdispatch.dylib             	       0x185f7edc0 _dispatch_worker_thread + 324
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x000000089dd14780   x1: 0x0000000000000060   x2: 0x000065a203bb2818   x3: 0x0000000000000001
    x4: 0x000000089d954780   x5: 0x000000000000000c   x6: 0x000000018b6f91c5   x7: 0x0000000000000000
    x8: 0x0000000000000000   x9: 0x0000000000000000  x10: 0x0000000000000000  x11: 0x0000000000000000
   x12: 0x0057d2be00868996  x13: 0x0057c2bd808682aa  x14: 0x0000000000068800  x15: 0x0000000000000008
   x16: 0x7e6865a203bb281e  x17: 0x000000057c2bdaaa  x18: 0x0000000000000000  x19: 0x000000089d014000
   x20: 0x000000089d014668  x21: 0x000000089dd14780  x22: 0x00000001f2af6160  x23: 0x00000000a1a1a1a1
   x24: 0x0f00ffffffffffff  x25: 0xa3a3a3a3a3a3a3a3  x26: 0x0000000000000001  x27: 0x00000001f2b50000
   x28: 0x00000001f0afd000   fp: 0x000000016d92a880   lr: 0x0000000185ce3c84
    sp: 0x000000016d92a840   pc: 0x0000000185cdc120 cpsr: 0x00000000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x1024d4000 -        0x10258ffff LocalDictation (*) <bfb7628c-4eb1-3d62-adb2-bc1e4ccdf641> */LocalDictation.app/Contents/MacOS/LocalDictation
       0x10b35c000 -        0x10b49ffff com.apple.audio.units.Components (1.14) <9155d5f9-804c-3e9b-a2d9-b4ccff316f05> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
       0x102970000 -        0x10297bfff libobjc-trampolines.dylib (*) <f8bd9069-8c4f-37ea-af9a-2b1060f54e4f> /usr/lib/libobjc-trampolines.dylib
       0x116e90000 -        0x1176b7fff com.apple.AGXMetalG16G-B0 (341.11) <a22549f3-d4f5-3b88-af18-e06837f0d352> /System/Library/Extensions/AGXMetalG16G_B0.bundle/Contents/MacOS/AGXMetalG16G_B0
       0x185cd4000 -        0x185d2748b libobjc.A.dylib (*) <5a0aab4e-0c1a-3680-82c9-43dc4007a6e7> /usr/lib/libobjc.A.dylib
       0x186169000 -        0x1866afabf com.apple.CoreFoundation (6.9) <3c4a3add-9e48-33da-82ee-80520e6cbe3b> /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
       0x1879b3000 -        0x18895625f com.apple.Foundation (6.9) <00467f1f-216a-36fe-8587-c820c7e0437d> /System/Library/Frameworks/Foundation.framework/Versions/C/Foundation
       0x18a5b2000 -        0x18bcdeb9f com.apple.AppKit (6.9) <3c0949bb-e361-369a-80b7-17440eb09e98> /System/Library/Frameworks/AppKit.framework/Versions/C/AppKit
       0x1b9c51000 -        0x1bb3905bf com.apple.SwiftUI (7.1.13.1.401) <6a83fd25-8f6d-3773-9285-cea41ce49fb5> /System/Library/Frameworks/SwiftUI.framework/Versions/A/SwiftUI
       0x185d59000 -        0x185df7f63 dyld (*) <b50f5a1a-be81-3068-92e1-3554f2be478a> /usr/lib/dyld
               0x0 - 0xffffffffffffffff ??? (*) <00000000-0000-0000-0000-000000000000> ???
       0x1860e6000 -        0x18612249f libsystem_kernel.dylib (*) <9fe7c84d-0c2b-363f-bee5-6fd76d67a227> /usr/lib/system/libsystem_kernel.dylib
       0x185f6b000 -        0x185fb1e9f libdispatch.dylib (*) <8fb392ae-401f-399a-96ae-41531cf91162> /usr/lib/system/libdispatch.dylib
       0x186123000 -        0x18612fabb libsystem_pthread.dylib (*) <e95973b8-824c-361e-adf4-390747c40897> /usr/lib/system/libsystem_pthread.dylib
       0x19270c000 -        0x192734d7f com.apple.audio.caulk (1.0) <9c791aec-e0d3-3ace-ac9e-e7a4d59b7762> /System/Library/PrivateFrameworks/caulk.framework/Versions/A/caulk
       0x19936b000 -        0x1998f915f libswiftCore.dylib (*) <9391dc96-6abf-38c1-b3bb-0b5d2ec1ad84> /usr/lib/swift/libswiftCore.dylib
       0x189230000 -        0x1899dc0ff com.apple.audio.CoreAudio (5.0) <7d9dbf1d-2cfe-3601-bd04-2578b26d373b> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio
       0x197648000 -        0x19770a5df com.apple.MediaExperience (1.0) <9d344825-1ed8-36d0-88ed-daf41eb49e45> /System/Library/PrivateFrameworks/MediaExperience.framework/Versions/A/MediaExperience

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

VM Region Summary:
ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)
Writable regions: Total=173.9M written=753K(0%) resident=657K(0%) swapped_out=96K(0%) unallocated=173.2M(100%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               256K        2 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                           192K       10 
ColorSync                           16K        1 
CoreAnimation                     3776K      114 
CoreGraphics                       128K        8 
CoreUI image data                  592K        5 
Foundation                         912K       11 
Image IO                            64K        4 
Kernel Alloc Once                   32K        1 
MALLOC                           147.4M       31 
MALLOC guard page                 3968K        4 
STACK GUARD                       56.3M       19 
Stack                             17.5M       19 
VM_ALLOCATE                        464K       19 
VM_ALLOCATE (reserved)             768K        1         reserved VM address space (unallocated)
__AUTH                            5803K      642 
__AUTH_CONST                      88.5M     1023 
__CTF                               824        1 
__DATA                            29.8M      974 
__DATA_CONST                      32.8M     1032 
__DATA_DIRTY                      8768K      885 
__FONT_DATA                        2352        1 
__INFO_FILTER                         8        1 
__LINKEDIT                       595.2M        5 
__OBJC_RO                         78.3M        1 
__OBJC_RW                         2567K        1 
__TEXT                             1.2G     1055 
__TPRO_CONST                       128K        2 
mapped file                      494.0M       44 
page table in kernel               657K        1 
shared memory                     2992K       15 
===========                     =======  ======= 
TOTAL                              2.7G     5934 
TOTAL, minus reserved VM space     2.7G     5934 


-----------
Full Report
-----------

{"app_name":"LocalDictation","timestamp":"2025-11-07 13:55:45.00 -0600","app_version":"1.0","slice_uuid":"bfb7628c-4eb1-3d62-adb2-bc1e4ccdf641","build_version":"1","platform":1,"bundleID":"com.yourname.LocalDictation","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.1 (25B78)","roots_installed":0,"name":"LocalDictation","incident_id":"C0CC43BE-9805-4CCD-BC61-92A7B85B218F"}
{
  "uptime" : 100000,
  "procRole" : "Foreground",
  "version" : 2,
  "userID" : 501,
  "deployVersion" : 210,
  "modelCode" : "Mac16,12",
  "coalitionID" : 1137,
  "osVersion" : {
    "train" : "macOS 26.1",
    "build" : "25B78",
    "releaseType" : "User"
  },
  "captureTime" : "2025-11-07 13:55:42.6209 -0600",
  "codeSigningMonitor" : 2,
  "incident" : "C0CC43BE-9805-4CCD-BC61-92A7B85B218F",
  "pid" : 24217,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-11-07 13:55:14.0002 -0600",
  "procStartAbsTime" : 2430036723710,
  "procExitAbsTime" : 2430719520886,
  "procName" : "LocalDictation",
  "procPath" : "\/Users\/USER\/*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
  "bundleInfo" : {"CFBundleShortVersionString":"1.0","CFBundleVersion":"1","CFBundleIdentifier":"com.yourname.LocalDictation"},
  "storeInfo" : {"deviceIdentifierForVendor":"A3BD9721-7479-5497-9472-92D4BCF93192","thirdParty":true},
  "parentProc" : "Exited process",
  "parentPid" : 24204,
  "coalitionName" : "com.googlecode.iterm2",
  "crashReporterKey" : "C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2",
  "appleIntelligenceStatus" : {"state":"available"},
  "developerMode" : 1,
  "responsiblePid" : 1392,
  "responsibleProc" : "iTerm2",
  "codeSigningID" : "com.yourname.LocalDictation",
  "codeSigningTeamID" : "",
  "codeSigningFlags" : 570503957,
  "codeSigningValidationCategory" : 10,
  "codeSigningTrustLevel" : 4294967295,
  "codeSigningAuxiliaryInfo" : 0,
  "instructionByteStream" : {"beforePC":"gf7\/VMADX9bAA1\/WQW09kCGgOZG9BQAUAAAA6m3\/\/1QQAED5Aq59kg==","atPC":"URBA+TEDEDYwBAA2Ef5305H+\/7Q\/BgDxYAIAVBEg4NIRAhHL4QMQqg=="},
  "bootSessionUUID" : "8C7A2380-7264-4158-8047-64B17EB94963",
  "wakeTime" : 18640,
  "sleepWakeUUID" : "DD9B40A7-79AE-495C-B972-70C6C7761451",
  "sip" : "enabled",
  "vmRegionInfo" : "0x65a203bb2838 is not in any region.  \n      REGION TYPE                    START - END         [ VSIZE] PRT\/MAX SHRMOD  REGION DETAIL\n      UNUSED SPACE AT START\n--->  \n      UNUSED SPACE AT END",
  "exception" : {"codes":"0x0000000000000001, 0x000065a203bb2838","rawCodes":[1,111746521704504],"type":"EXC_BAD_ACCESS","signal":"SIGSEGV","subtype":"KERN_INVALID_ADDRESS at 0x000065a203bb2838"},
  "vmregioninfo" : "0x65a203bb2838 is not in any region.  \n      REGION TYPE                    START - END         [ VSIZE] PRT\/MAX SHRMOD  REGION DETAIL\n      UNUSED SPACE AT START\n--->  \n      UNUSED SPACE AT END",
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":4480,"task_for_pid":63},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":10781885,"threadState":{"x":[{"value":37007476608},{"value":96},{"value":111746521704472},{"value":1},{"value":37003544448},{"value":12},{"value":6634312133,"symbolLocation":693,"symbol":"_OBJC_$_INSTANCE_METHODS_NSControl(NSControlAccessibility|NSObjectAccessibilityChildHelpers|NSControlAccessibilityAdditions|NSControlEvents|Debugging|_NSTracking|NSControlDebugShowInfo|NSConstraintBasedLayout|NSConstraintBasedLayoutInternal)"},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":24720036468263318},{"value":24702442134733482},{"value":428032},{"value":8},{"value":9108641992878532638},{"value":23558085290},{"value":0},{"value":36993843200},{"value":36993844840},{"value":37007476608},{"value":8366547296,"symbolLocation":224,"symbol":"_main_thread"},{"value":2711724449},{"value":1081145385545629695},{"value":11791448172606497699},{"value":1},{"value":8366915584,"symbolLocation":1360,"symbol":"_NSEnablePersistentUI.sEnabled"},{"value":8333021184,"symbolLocation":0,"symbol":"OBJC_IVAR_$_NSApplication._insertedCharPaletteMenuItem"}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6539852932},"cpsr":{"value":0},"fp":{"value":6133295232},"sp":{"value":6133295168},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6539821344,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":33056,"symbol":"objc_release","symbolLocation":16,"imageIndex":4},{"imageOffset":64644,"symbol":"AutoreleasePoolPage::releaseUntil(objc_object**)","symbolLocation":204,"imageIndex":4},{"imageOffset":49488,"symbol":"objc_autoreleasePoolPop","symbolLocation":244,"imageIndex":4},{"imageOffset":202372,"symbol":"_CFAutoreleasePoolPop","symbolLocation":32,"imageIndex":5},{"imageOffset":98580,"symbol":"-[NSAutoreleasePool drain]","symbolLocation":136,"imageIndex":6},{"imageOffset":100272,"symbol":"-[NSApplication run]","symbolLocation":416,"imageIndex":7},{"imageOffset":18140,"symbol":"NSApplicationMain","symbolLocation":880,"imageIndex":7},{"imageOffset":1118480,"symbol":"specialized runApp(_:)","symbolLocation":168,"imageIndex":8},{"imageOffset":5022384,"symbol":"runApp<A>(_:)","symbolLocation":112,"imageIndex":8},{"imageOffset":7945556,"symbol":"static App.main()","symbolLocation":224,"imageIndex":8},{"imageOffset":389316,"sourceFile":"\/<compiler-generated>","symbol":"static LocalDictationApp.$main()","symbolLocation":40,"imageIndex":0},{"imageOffset":389936,"sourceFile":"LocalDictationApp.swift","symbol":"main","symbolLocation":12,"imageIndex":0},{"imageOffset":36180,"symbol":"start","symbolLocation":7184,"imageIndex":9}]},{"id":10781966,"threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":677518206042112},{"value":0},{"value":677518206042112},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":157747},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":677518206042112},{"value":0},{"value":677518206042112},{"value":6133849816},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6133849664},"sp":{"value":6133849584},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"queue":"com.apple.root.user-interactive-qos","frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":11},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":10860688,"symbol":"-[NSRunLoop(NSRunLoop) runMode:beforeDate:]","symbolLocation":212,"imageIndex":6},{"imageOffset":5706836,"symbol":"-[NSAnimation _runBlocking]","symbolLocation":412,"imageIndex":7},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":12},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":12},{"imageOffset":231916,"symbol":"<deduplicated_symbol>","symbolLocation":32,"imageIndex":12},{"imageOffset":82236,"symbol":"_dispatch_root_queue_drain","symbolLocation":736,"imageIndex":12},{"imageOffset":83844,"symbol":"_dispatch_worker_thread2","symbolLocation":180,"imageIndex":12},{"imageOffset":11792,"symbol":"_pthread_wqthread","symbolLocation":232,"imageIndex":13},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":13}]},{"id":10781972,"frames":[],"threadState":{"x":[{"value":6135574528},{"value":18955},{"value":6135037952},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6135574528},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10781976,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":100068443029504},{"value":0},{"value":100068443029504},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23299},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":100068443029504},{"value":0},{"value":100068443029504},{"value":6136144008},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6136143856},"sp":{"value":6136143776},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":11},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":720052,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":7},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10781995,"name":"caulk.messenger.shared:17","threadState":{"x":[{"value":14},{"value":17985176186},{"value":0},{"value":6136721514},{"value":17985176160},{"value":25},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":36996056416},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6136721280},"sp":{"value":6136721248},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10781996,"name":"caulk.messenger.shared:high","threadState":{"x":[{"value":14},{"value":41731},{"value":41731},{"value":15},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":1},{"value":36989739368},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":36996056640},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6137294720},"sp":{"value":6137294688},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10782069,"name":"com.apple.audio.toolbox.AUScheduledParameterRefresher","threadState":{"x":[{"value":14},{"value":17985227830},{"value":0},{"value":6138441862},{"value":17985227776},{"value":53},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":36991601112},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6138441600},"sp":{"value":6138441568},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10782070,"name":"caulk::deferred_logger","threadState":{"x":[{"value":14},{"value":2},{"value":0},{"value":1},{"value":0},{"value":1},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":4337942552},{"value":6139014840},{"value":8191},{"value":1},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":36991601336},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6139015040},"sp":{"value":6139015008},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10782108,"threadState":{"x":[{"value":8367656368,"symbolLocation":0,"symbol":"OBJC_CLASS_$__TtCs15__StringStorage"},{"value":0},{"value":88},{"value":1},{"value":4334297504},{"value":88},{"value":3472328296311828018},{"value":18446726482597246976},{"value":4294942772},{"value":1},{"value":7453316016319589229},{"value":7451046482451718757},{"value":4334297592},{"value":36978341680},{"value":116},{"value":8366679864,"symbolLocation":0,"symbol":"OBJC_CLASS_$___NSCFString"},{"value":6539904364,"symbolLocation":0,"symbol":"objc_opt_self"},{"value":8389549272},{"value":0},{"value":88},{"value":8},{"value":144},{"value":17293822569102704728},{"value":9223372041189073280},{"value":14987979559889010776},{"value":265},{"value":6139584800},{"value":6139585072},{"value":276}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6868752508},"cpsr":{"value":536870912},"fp":{"value":6139584624},"sp":{"value":6139584592},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6868752508},"far":{"value":0}},"queue":"com.LocalDictation.DebugLogger","frames":[{"imageOffset":3287164,"symbol":"_allocateStringStorage(codeUnitCapacity:)","symbolLocation":160,"imageIndex":15},{"imageOffset":4435560,"symbol":"specialized static __StringStorage.create(initializingFrom:codeUnitCapacity:isASCII:)","symbolLocation":52,"imageIndex":15},{"imageOffset":4436516,"symbol":"specialized static String._uncheckedFromUTF8(_:isASCII:)","symbolLocation":40,"imageIndex":15},{"imageOffset":4490424,"symbol":"String.init(cString:)","symbolLocation":72,"imageIndex":15},{"imageOffset":7238348,"symbol":"specialized String.withFileSystemRepresentation<A>(_:)","symbolLocation":216,"imageIndex":6},{"imageOffset":7715280,"symbol":"specialized _SwiftURL.__allocating_init(fileURLWithPath:)","symbolLocation":124,"imageIndex":6},{"imageOffset":7426364,"symbol":"URL.init(fileURLWithPath:)","symbolLocation":172,"imageIndex":6},{"imageOffset":92892,"sourceLine":78,"sourceFile":"DebugLogger.swift","symbol":"closure #1 in DebugLogger.log(_:file:function:line:level:)","imageIndex":0,"symbolLocation":768},{"imageOffset":95140,"sourceFile":"\/<compiler-generated>","symbol":"partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:)","symbolLocation":60,"imageIndex":0},{"imageOffset":95544,"sourceFile":"\/<compiler-generated>","symbol":"thunk for @escaping @callee_guaranteed @Sendable () -> ()","symbolLocation":48,"imageIndex":0},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":12},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":12},{"imageOffset":42216,"symbol":"_dispatch_lane_serial_drain","symbolLocation":740,"imageIndex":12},{"imageOffset":44996,"symbol":"_dispatch_lane_invoke","symbolLocation":388,"imageIndex":12},{"imageOffset":87156,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":292,"imageIndex":12},{"imageOffset":85356,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":12},{"imageOffset":11852,"symbol":"_pthread_wqthread","symbolLocation":292,"imageIndex":13},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":13}]},{"id":10782111,"frames":[],"threadState":{"x":[{"value":6141308928},{"value":116503},{"value":6140772352},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6141308928},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10782114,"frames":[],"threadState":{"x":[{"value":6141882368},{"value":174339},{"value":6141345792},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6141882368},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10784030,"frames":[],"threadState":{"x":[{"value":6137868288},{"value":131607},{"value":6137331712},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6137868288},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10785163,"frames":[],"threadState":{"x":[{"value":6134427648},{"value":136971},{"value":6133891072},{"value":0},{"value":409602},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6134427648},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10785164,"frames":[],"threadState":{"x":[{"value":6135001088},{"value":107539},{"value":6134464512},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6135001088},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10785165,"frames":[],"threadState":{"x":[{"value":6140162048},{"value":149263},{"value":6139625472},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6140162048},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10786275,"frames":[],"threadState":{"x":[{"value":6143602688},{"value":149507},{"value":6143066112},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6143602688},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10786276,"frames":[],"threadState":{"x":[{"value":6144176128},{"value":0},{"value":6143639552},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6144176128},"esr":{"value":0},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10787934,"name":"com.apple.audio.IOThread.client","threadState":{"x":[{"value":14},{"value":156443},{"value":0},{"value":0},{"value":0},{"value":16},{"value":4484689296},{"value":2},{"value":1},{"value":2256565616035561475},{"value":2199023256064},{"value":2199023256066},{"value":48},{"value":9600},{"value":14},{"value":4337993104},{"value":18446744073709551579},{"value":8389600416},{"value":0},{"value":36992006456},{"value":36992006448},{"value":36992006480},{"value":1},{"value":36977387744},{"value":13},{"value":0},{"value":6603101947},{"value":36992006448},{"value":36992005632}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751956904},"cpsr":{"value":1610612736},"fp":{"value":6140734720},"sp":{"value":6140734704},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059324},"far":{"value":0}},"frames":[{"imageOffset":3004,"symbol":"semaphore_wait_signal_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":126888,"symbol":"caulk::mach::semaphore::wait_signal_or_error(caulk::mach::semaphore&)","symbolLocation":36,"imageIndex":14},{"imageOffset":2122372,"symbol":"HALC_ProxyIOContext::IOWorkLoop()","symbolLocation":5052,"imageIndex":16},{"imageOffset":2115616,"symbol":"invocation function for block in HALC_ProxyIOContext::HALC_ProxyIOContext(unsigned int, unsigned int)","symbolLocation":172,"imageIndex":16},{"imageOffset":4006592,"symbol":"HALC_IOThread::Entry(void*)","symbolLocation":88,"imageIndex":16},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10788145,"name":"AudioSession - RootQueue","threadState":{"x":[{"value":14},{"value":4294967115611373572},{"value":999999958},{"value":68719460488},{"value":36961382080},{"value":6835597824},{"value":0},{"value":0},{"value":999999958},{"value":3},{"value":13835058055282163714},{"value":80000000},{"value":51498612097657572},{"value":51481017764127415},{"value":108544},{"value":26},{"value":18446744073709551578},{"value":8389600392},{"value":0},{"value":2430835914736},{"value":36989850560},{"value":1000000000},{"value":36989850424},{"value":6142456032},{"value":0},{"value":0},{"value":18446744071411073023},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6542728324},"cpsr":{"value":2147483648},"fp":{"value":6142455616},"sp":{"value":6142455584},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059336},"far":{"value":0}},"frames":[{"imageOffset":3016,"symbol":"semaphore_timedwait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":224388,"symbol":"_dispatch_sema4_timedwait","symbolLocation":64,"imageIndex":12},{"imageOffset":16136,"symbol":"_dispatch_semaphore_wait_slow","symbolLocation":76,"imageIndex":12},{"imageOffset":81344,"symbol":"_dispatch_worker_thread","symbolLocation":324,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4333584384,
    "size" : 770048,
    "uuid" : "bfb7628c-4eb1-3d62-adb2-bc1e4ccdf641",
    "path" : "*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
    "name" : "LocalDictation"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4483039232,
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
    "base" : 4338417664,
    "size" : 49152,
    "uuid" : "f8bd9069-8c4f-37ea-af9a-2b1060f54e4f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4679335936,
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
    "base" : 6539788288,
    "size" : 341132,
    "uuid" : "5a0aab4e-0c1a-3680-82c9-43dc4007a6e7",
    "path" : "\/usr\/lib\/libobjc.A.dylib",
    "name" : "libobjc.A.dylib"
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
    "base" : 6544056320,
    "size" : 246944,
    "uuid" : "9fe7c84d-0c2b-363f-bee5-6fd76d67a227",
    "path" : "\/usr\/lib\/system\/libsystem_kernel.dylib",
    "name" : "libsystem_kernel.dylib"
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
    "base" : 6865465344,
    "size" : 5824864,
    "uuid" : "9391dc96-6abf-38c1-b3bb-0b5d2ec1ad84",
    "path" : "\/usr\/lib\/swift\/libswiftCore.dylib",
    "name" : "libswiftCore.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6595739648,
    "CFBundleShortVersionString" : "5.0",
    "CFBundleIdentifier" : "com.apple.audio.CoreAudio",
    "size" : 8044800,
    "uuid" : "7d9dbf1d-2cfe-3601-bd04-2578b26d373b",
    "path" : "\/System\/Library\/Frameworks\/CoreAudio.framework\/Versions\/A\/CoreAudio",
    "name" : "CoreAudio",
    "CFBundleVersion" : "5.0"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 6834913280,
    "CFBundleShortVersionString" : "1.0",
    "CFBundleIdentifier" : "com.apple.MediaExperience",
    "size" : 796128,
    "uuid" : "9d344825-1ed8-36d0-88ed-daf41eb49e45",
    "path" : "\/System\/Library\/PrivateFrameworks\/MediaExperience.framework\/Versions\/A\/MediaExperience",
    "name" : "MediaExperience",
    "CFBundleVersion" : "1"
  }
],
  "sharedCache" : {
  "base" : 6539247616,
  "size" : 5609635840,
  "uuid" : "b69ff43c-dbfd-3fb1-b4fe-a8fe32ea1062"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=173.9M written=753K(0%) resident=657K(0%) swapped_out=96K(0%) unallocated=173.2M(100%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               256K        2 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                           192K       10 \nColorSync                           16K        1 \nCoreAnimation                     3776K      114 \nCoreGraphics                       128K        8 \nCoreUI image data                  592K        5 \nFoundation                         912K       11 \nImage IO                            64K        4 \nKernel Alloc Once                   32K        1 \nMALLOC                           147.4M       31 \nMALLOC guard page                 3968K        4 \nSTACK GUARD                       56.3M       19 \nStack                             17.5M       19 \nVM_ALLOCATE                        464K       19 \nVM_ALLOCATE (reserved)             768K        1         reserved VM address space (unallocated)\n__AUTH                            5803K      642 \n__AUTH_CONST                      88.5M     1023 \n__CTF                               824        1 \n__DATA                            29.8M      974 \n__DATA_CONST                      32.8M     1032 \n__DATA_DIRTY                      8768K      885 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       595.2M        5 \n__OBJC_RO                         78.3M        1 \n__OBJC_RW                         2567K        1 \n__TEXT                             1.2G     1055 \n__TPRO_CONST                       128K        2 \nmapped file                      494.0M       44 \npage table in kernel               657K        1 \nshared memory                     2992K       15 \n===========                     =======  ======= \nTOTAL                              2.7G     5934 \nTOTAL, minus reserved VM space     2.7G     5934 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "062be8e86d79a0d3d9b78f1db2bb1c158838f347",
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
