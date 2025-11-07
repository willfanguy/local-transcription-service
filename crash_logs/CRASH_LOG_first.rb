-------------------------------------
Translated Report (Full Report Below)
-------------------------------------
Process:             LocalDictation [58197]
Path:                /Users/USER/*/LocalDictation.app/Contents/MacOS/LocalDictation
Identifier:          com.yourname.LocalDictation
Version:             1.0 (1)
Code Type:           ARM-64 (Native)
Role:                Foreground
Parent Process:      zsh [55323]
Coalition:           com.googlecode.iterm2 [1137]
Responsible Process: iTerm2 [1392]
User ID:             501

Date/Time:           2025-11-07 13:26:11.2386 -0600
Launch Time:         2025-11-07 13:25:41.1563 -0600
Hardware Model:      Mac16,12
OS Version:          macOS 26.1 (25B78)
Release Type:        User

Crash Reporter Key:  C64B9C4C-0D6F-3F04-B934-0E2E0B50B8F2
Incident Identifier: B71759D8-D9DD-4837-A604-9108A74D4BA0

Sleep/Wake UUID:       DD9B40A7-79AE-495C-B972-70C6C7761451

Time Awake Since Boot: 99000 seconds
Time Since Wake:       16869 seconds

System Integrity Protection: enabled

Triggered by Thread: 0, Dispatch Queue: com.apple.main-thread

Exception Type:    EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0x0000310873940850
Exception Codes:   0x0000000000000001, 0x0000310873940850


VM Region Info: 0x310873940850 is not in any region.  
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
10  LocalDictation                	       0x102655dfc static LocalDictationApp.$main() + 40
11  LocalDictation                	       0x102656068 main + 12
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

Thread 7:

Thread 8:

Thread 9::  Dispatch queue: com.LocalDictation.DebugLogger
0   libicucore.A.dylib            	       0x189ff831c icu::SimpleTimeZone::deleteTransitionRules() + 156
1   libicucore.A.dylib            	       0x189ff83e8 icu::SimpleTimeZone::~SimpleTimeZone() + 52
2   libicucore.A.dylib            	       0x189fbd160 icu::OlsonTimeZone::~OlsonTimeZone() + 96
3   libicucore.A.dylib            	       0x189fbd2f0 icu::OlsonTimeZone::~OlsonTimeZone() + 16
4   libicucore.A.dylib            	       0x189ef044c icu::Calendar::~Calendar() + 92
5   libicucore.A.dylib            	       0x189f1dd40 icu::DateFormat::format(double, icu::UnicodeString&, icu::FieldPosition&) const + 408
6   libicucore.A.dylib            	       0x18a032e0c udat_format + 352
7   CoreFoundation                	       0x1861f1e40 CFDateFormatterCreateStringWithAbsoluteTime + 192
8   Foundation                    	       0x188342d54 -[NSDateFormatter stringForObjectValue:] + 292
9   LocalDictation                	       0x10260d8fc closure #1 in DebugLogger.log(_:file:function:line:level:) + 660 (DebugLogger.swift:77)
10  LocalDictation                	       0x10260e230 partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:) + 60
11  LocalDictation                	       0x10260e3c4 thunk for @escaping @callee_guaranteed @Sendable () -> () + 48
12  libdispatch.dylib             	       0x185f6cb5c _dispatch_call_block_and_release + 32
13  libdispatch.dylib             	       0x185f86ac4 _dispatch_client_callout + 16
14  libdispatch.dylib             	       0x185f754e8 _dispatch_lane_serial_drain + 740
15  libdispatch.dylib             	       0x185f75fc4 _dispatch_lane_invoke + 388
16  libdispatch.dylib             	       0x185f80474 _dispatch_root_queue_drain_deferred_wlh + 292
17  libdispatch.dylib             	       0x185f7fd6c _dispatch_workloop_worker_thread + 692
18  libsystem_pthread.dylib       	       0x186125e4c _pthread_wqthread + 292
19  libsystem_pthread.dylib       	       0x186124b9c start_wqthread + 8

Thread 10:

Thread 11:: AudioSession - RootQueue
0   libsystem_kernel.dylib        	       0x1860e6bc8 semaphore_timedwait_trap + 8
1   libdispatch.dylib             	       0x185fa1c84 _dispatch_sema4_timedwait + 64
2   libdispatch.dylib             	       0x185f6ef08 _dispatch_semaphore_wait_slow + 76
3   libdispatch.dylib             	       0x185f7edc0 _dispatch_worker_thread + 324
4   libsystem_pthread.dylib       	       0x186129c08 _pthread_start + 136
5   libsystem_pthread.dylib       	       0x186124ba8 thread_start + 8

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


Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000bdb284780   x1: 0x0000000000000060   x2: 0x0000310873940830   x3: 0x0000000000000001
    x4: 0x0000000bd9f08480   x5: 0x000000000000000c   x6: 0x000000018b6f91c5   x7: 0x0000000000000000
    x8: 0x0000000000000000   x9: 0x0000000000000000  x10: 0x0000000000000000  x11: 0x0000000000000000
   x12: 0x0059b2cd008bb8b2  x13: 0x0059a2cc808bb1ce  x14: 0x00000000000bb800  x15: 0x0000000000000008
   x16: 0x6790310873940832  x17: 0x000000059a2cc9ce  x18: 0x0000000000000000  x19: 0x0000000bd8c08000
   x20: 0x0000000bd8c08680  x21: 0x0000000bdb284780  x22: 0x00000001f2af6160  x23: 0x00000000a1a1a1a1
   x24: 0x0f00ffffffffffff  x25: 0xa3a3a3a3a3a3a3a3  x26: 0x0000000000000001  x27: 0x00000001f2b50000
   x28: 0x00000001f0afd000   fp: 0x000000016d8069d0   lr: 0x0000000185ce3c84
    sp: 0x000000016d806990   pc: 0x0000000185cdc120 cpsr: 0x00000000
   far: 0x0000000000000000  esr: 0x56000080 (Syscall)

Binary Images:
       0x1025f8000 -        0x1026affff LocalDictation (*) <35e96ff1-979e-31e0-a805-4b0a98ef18ec> */LocalDictation.app/Contents/MacOS/LocalDictation
       0x10b328000 -        0x10b46bfff com.apple.audio.units.Components (1.14) <9155d5f9-804c-3e9b-a2d9-b4ccff316f05> /System/Library/Components/CoreAudio.component/Contents/MacOS/CoreAudio
       0x10b0ac000 -        0x10b0b7fff libobjc-trampolines.dylib (*) <f8bd9069-8c4f-37ea-af9a-2b1060f54e4f> /usr/lib/libobjc-trampolines.dylib
       0x116e5c000 -        0x117683fff com.apple.AGXMetalG16G-B0 (341.11) <a22549f3-d4f5-3b88-af18-e06837f0d352> /System/Library/Extensions/AGXMetalG16G_B0.bundle/Contents/MacOS/AGXMetalG16G_B0
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
       0x189e01000 -        0x18a0d2819 libicucore.A.dylib (*) <ec990bc7-956f-300a-8870-118269cb7e73> /usr/lib/libicucore.A.dylib
       0x197648000 -        0x19770a5df com.apple.MediaExperience (1.0) <9d344825-1ed8-36d0-88ed-daf41eb49e45> /System/Library/PrivateFrameworks/MediaExperience.framework/Versions/A/MediaExperience
       0x189230000 -        0x1899dc0ff com.apple.audio.CoreAudio (5.0) <7d9dbf1d-2cfe-3601-bd04-2578b26d373b> /System/Library/Frameworks/CoreAudio.framework/Versions/A/CoreAudio

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
Writable regions: Total=173.1M written=2129K(1%) resident=641K(0%) swapped_out=1488K(1%) unallocated=171.0M(99%)

                                VIRTUAL   REGION 
REGION TYPE                        SIZE    COUNT (non-coalesced) 
===========                     =======  ======= 
Accelerate framework               256K        2 
Activity Tracing                   256K        1 
AttributeGraph Data               1024K        1 
CG image                           192K        9 
ColorSync                           16K        1 
CoreAnimation                     3392K      108 
CoreGraphics                       112K        7 
CoreUI image data                  320K        3 
Foundation                         912K       11 
Image IO                            64K        4 
Kernel Alloc Once                   32K        1 
MALLOC                           147.4M       31 
MALLOC guard page                 4112K        4 
STACK GUARD                       56.3M       18 
Stack                             17.0M       18 
VM_ALLOCATE                        464K       20 
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
mapped file                      493.9M       43 
page table in kernel               641K        1 
shared memory                     2496K       16 
===========                     =======  ======= 
TOTAL                              2.7G     5923 
TOTAL, minus reserved VM space     2.7G     5923 


-----------
Full Report
-----------

{"app_name":"LocalDictation","timestamp":"2025-11-07 13:26:14.00 -0600","app_version":"1.0","slice_uuid":"35e96ff1-979e-31e0-a805-4b0a98ef18ec","build_version":"1","platform":1,"bundleID":"com.yourname.LocalDictation","share_with_app_devs":1,"is_first_party":0,"bug_type":"309","os_version":"macOS 26.1 (25B78)","roots_installed":0,"name":"LocalDictation","incident_id":"B71759D8-D9DD-4837-A604-9108A74D4BA0"}
{
  "uptime" : 99000,
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
  "captureTime" : "2025-11-07 13:26:11.2386 -0600",
  "codeSigningMonitor" : 2,
  "incident" : "B71759D8-D9DD-4837-A604-9108A74D4BA0",
  "pid" : 58197,
  "translated" : false,
  "cpuType" : "ARM-64",
  "roots_installed" : 0,
  "bug_type" : "309",
  "procLaunch" : "2025-11-07 13:25:41.1563 -0600",
  "procStartAbsTime" : 2387489591051,
  "procExitAbsTime" : 2388208808219,
  "procName" : "LocalDictation",
  "procPath" : "\/Users\/USER\/*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
  "bundleInfo" : {"CFBundleShortVersionString":"1.0","CFBundleVersion":"1","CFBundleIdentifier":"com.yourname.LocalDictation"},
  "storeInfo" : {"deviceIdentifierForVendor":"A3BD9721-7479-5497-9472-92D4BCF93192","thirdParty":true},
  "parentProc" : "zsh",
  "parentPid" : 55323,
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
  "wakeTime" : 16869,
  "sleepWakeUUID" : "DD9B40A7-79AE-495C-B972-70C6C7761451",
  "sip" : "enabled",
  "vmRegionInfo" : "0x310873940850 is not in any region.  \n      REGION TYPE                    START - END         [ VSIZE] PRT\/MAX SHRMOD  REGION DETAIL\n      UNUSED SPACE AT START\n--->  \n      UNUSED SPACE AT END",
  "exception" : {"codes":"0x0000000000000001, 0x0000310873940850","rawCodes":[1,53912368580688],"type":"EXC_BAD_ACCESS","signal":"SIGSEGV","subtype":"KERN_INVALID_ADDRESS at 0x0000310873940850"},
  "vmregioninfo" : "0x310873940850 is not in any region.  \n      REGION TYPE                    START - END         [ VSIZE] PRT\/MAX SHRMOD  REGION DETAIL\n      UNUSED SPACE AT START\n--->  \n      UNUSED SPACE AT END",
  "extMods" : {"caller":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"system":{"thread_create":0,"thread_set_state":4480,"task_for_pid":63},"targeted":{"thread_create":0,"thread_set_state":0,"task_for_pid":0},"warnings":0},
  "faultingThread" : 0,
  "threads" : [{"triggered":true,"id":10370755,"threadState":{"x":[{"value":50921490304},{"value":96},{"value":53912368580656},{"value":1},{"value":50901058688},{"value":12},{"value":6634312133,"symbolLocation":693,"symbol":"_OBJC_$_INSTANCE_METHODS_NSControl(NSControlAccessibility|NSObjectAccessibilityChildHelpers|NSControlAccessibilityAdditions|NSControlEvents|Debugging|_NSTracking|NSControlDebugShowInfo|NSConstraintBasedLayout|NSConstraintBasedLayoutInternal)"},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":25247866474444978},{"value":25230272140915150},{"value":768000},{"value":8},{"value":7462518494921492530},{"value":24061462990},{"value":0},{"value":50881134592},{"value":50881136256},{"value":50921490304},{"value":8366547296,"symbolLocation":224,"symbol":"_main_thread"},{"value":2711724449},{"value":1081145385545629695},{"value":11791448172606497699},{"value":1},{"value":8366915584,"symbolLocation":1360,"symbol":"_NSEnablePersistentUI.sEnabled"},{"value":8333021184,"symbolLocation":0,"symbol":"OBJC_IVAR_$_NSApplication._insertedCharPaletteMenuItem"}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6539852932},"cpsr":{"value":0},"fp":{"value":6132099536},"sp":{"value":6132099472},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6539821344,"matchesCrashFrame":1},"far":{"value":0}},"queue":"com.apple.main-thread","frames":[{"imageOffset":33056,"symbol":"objc_release","symbolLocation":16,"imageIndex":4},{"imageOffset":64644,"symbol":"AutoreleasePoolPage::releaseUntil(objc_object**)","symbolLocation":204,"imageIndex":4},{"imageOffset":49488,"symbol":"objc_autoreleasePoolPop","symbolLocation":244,"imageIndex":4},{"imageOffset":202372,"symbol":"_CFAutoreleasePoolPop","symbolLocation":32,"imageIndex":5},{"imageOffset":98580,"symbol":"-[NSAutoreleasePool drain]","symbolLocation":136,"imageIndex":6},{"imageOffset":100272,"symbol":"-[NSApplication run]","symbolLocation":416,"imageIndex":7},{"imageOffset":18140,"symbol":"NSApplicationMain","symbolLocation":880,"imageIndex":7},{"imageOffset":1118480,"symbol":"specialized runApp(_:)","symbolLocation":168,"imageIndex":8},{"imageOffset":5022384,"symbol":"runApp<A>(_:)","symbolLocation":112,"imageIndex":8},{"imageOffset":7945556,"symbol":"static App.main()","symbolLocation":224,"imageIndex":8},{"imageOffset":384508,"sourceFile":"\/<compiler-generated>","symbol":"static LocalDictationApp.$main()","symbolLocation":40,"imageIndex":0},{"imageOffset":385128,"sourceFile":"LocalDictationApp.swift","symbol":"main","symbolLocation":12,"imageIndex":0},{"imageOffset":36180,"symbol":"start","symbolLocation":7184,"imageIndex":9}]},{"id":10370756,"threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":613540373200896},{"value":0},{"value":613540373200896},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":142851},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":613540373200896},{"value":0},{"value":613540373200896},{"value":6132653784},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6132653632},"sp":{"value":6132653552},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"queue":"com.apple.root.user-interactive-qos","frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":11},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":10860688,"symbol":"-[NSRunLoop(NSRunLoop) runMode:beforeDate:]","symbolLocation":212,"imageIndex":6},{"imageOffset":5706836,"symbol":"-[NSAnimation _runBlocking]","symbolLocation":412,"imageIndex":7},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":12},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":12},{"imageOffset":231916,"symbol":"<deduplicated_symbol>","symbolLocation":32,"imageIndex":12},{"imageOffset":82236,"symbol":"_dispatch_root_queue_drain","symbolLocation":736,"imageIndex":12},{"imageOffset":83844,"symbol":"_dispatch_worker_thread2","symbolLocation":180,"imageIndex":12},{"imageOffset":11792,"symbol":"_pthread_wqthread","symbolLocation":232,"imageIndex":13},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":13}]},{"id":10370765,"name":"com.apple.NSEventThread","threadState":{"x":[{"value":268451845},{"value":21592279046},{"value":8589934592},{"value":102267466285056},{"value":0},{"value":102267466285056},{"value":2},{"value":4294967295},{"value":0},{"value":17179869184},{"value":0},{"value":2},{"value":0},{"value":0},{"value":23811},{"value":0},{"value":18446744073709551569},{"value":8389597936},{"value":0},{"value":4294967295},{"value":2},{"value":102267466285056},{"value":0},{"value":102267466285056},{"value":6134374536},{"value":8589934592},{"value":21592279046},{"value":18446744073709550527},{"value":4412409862}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6544134184},"cpsr":{"value":0},"fp":{"value":6134374384},"sp":{"value":6134374304},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059444},"far":{"value":0}},"frames":[{"imageOffset":3124,"symbol":"mach_msg2_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":77864,"symbol":"mach_msg2_internal","symbolLocation":76,"imageIndex":11},{"imageOffset":39308,"symbol":"mach_msg_overwrite","symbolLocation":484,"imageIndex":11},{"imageOffset":4020,"symbol":"mach_msg","symbolLocation":24,"imageIndex":11},{"imageOffset":392080,"symbol":"__CFRunLoopServiceMachPort","symbolLocation":160,"imageIndex":5},{"imageOffset":386280,"symbol":"__CFRunLoopRun","symbolLocation":1188,"imageIndex":5},{"imageOffset":1147740,"symbol":"_CFRunLoopRunSpecificWithOptions","symbolLocation":532,"imageIndex":5},{"imageOffset":720052,"symbol":"_NSEventThread","symbolLocation":184,"imageIndex":7},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10370773,"name":"caulk.messenger.shared:17","threadState":{"x":[{"value":14},{"value":22984786586},{"value":0},{"value":6134952042},{"value":22984786560},{"value":25},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50883052224},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6134951808},"sp":{"value":6134951776},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10370774,"name":"caulk.messenger.shared:high","threadState":{"x":[{"value":14},{"value":42243},{"value":42243},{"value":15},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":1},{"value":50885474664},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50883052896},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6135525248},"sp":{"value":6135525216},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10370819,"name":"com.apple.audio.toolbox.AUScheduledParameterRefresher","threadState":{"x":[{"value":14},{"value":22984838262},{"value":0},{"value":6136672390},{"value":22984838208},{"value":53},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50888542008},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6136672128},"sp":{"value":6136672096},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10370820,"name":"caulk::deferred_logger","threadState":{"x":[{"value":14},{"value":2},{"value":0},{"value":1},{"value":0},{"value":1},{"value":0},{"value":0},{"value":0},{"value":4294967295},{"value":0},{"value":0},{"value":4479746072},{"value":6137245368},{"value":8191},{"value":1},{"value":18446744073709551580},{"value":8389600408},{"value":0},{"value":50888542232},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751837704},"cpsr":{"value":2147483648},"fp":{"value":6137245568},"sp":{"value":6137245536},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059312},"far":{"value":0}},"frames":[{"imageOffset":2992,"symbol":"semaphore_wait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":7688,"symbol":"caulk::semaphore::timed_wait(double)","symbolLocation":224,"imageIndex":14},{"imageOffset":7344,"symbol":"caulk::concurrent::details::worker_thread::run()","symbolLocation":32,"imageIndex":14},{"imageOffset":6480,"symbol":"void* caulk::thread_proxy<std::__1::tuple<caulk::thread::attributes, void (caulk::concurrent::details::worker_thread::*)(), std::__1::tuple<caulk::concurrent::details::worker_thread*>>>(void*)","symbolLocation":96,"imageIndex":14},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10370868,"frames":[],"threadState":{"x":[{"value":6140686336},{"value":20007},{"value":6140149760},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6140686336},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10373995,"frames":[],"threadState":{"x":[{"value":6133231616},{"value":134659},{"value":6132695040},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6133231616},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10373996,"threadState":{"x":[{"value":0},{"value":8},{"value":9},{"value":15},{"value":8393635856,"symbolLocation":48,"symbol":"vtable for icu::number::impl::UFormattedNumberData"},{"value":10},{"value":83},{"value":6133799024},{"value":6610191284,"symbolLocation":0,"symbol":"icu::SimpleTimeZone::~SimpleTimeZone()"},{"value":8393648480,"symbolLocation":24,"symbol":"vtable for icu::SimpleTimeZone"},{"value":0},{"value":1},{"value":15},{"value":4},{"value":256},{"value":0},{"value":8393648472,"symbolLocation":16,"symbol":"vtable for icu::SimpleTimeZone"},{"value":11153727478019943360},{"value":0},{"value":50883488704},{"value":50883488832},{"value":4337180528},{"value":0},{"value":4337180528},{"value":0},{"value":8262492752,"symbolLocation":0,"symbol":"kCFAllocatorSystemDefault"},{"value":50921478848},{"value":0},{"value":276}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6610191336},"cpsr":{"value":1610612736},"fp":{"value":6133798992},"sp":{"value":6133798976},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6610191132},"far":{"value":0}},"queue":"com.LocalDictation.DebugLogger","frames":[{"imageOffset":2061084,"symbol":"icu::SimpleTimeZone::deleteTransitionRules()","symbolLocation":156,"imageIndex":15},{"imageOffset":2061288,"symbol":"icu::SimpleTimeZone::~SimpleTimeZone()","symbolLocation":52,"imageIndex":15},{"imageOffset":1818976,"symbol":"icu::OlsonTimeZone::~OlsonTimeZone()","symbolLocation":96,"imageIndex":15},{"imageOffset":1819376,"symbol":"icu::OlsonTimeZone::~OlsonTimeZone()","symbolLocation":16,"imageIndex":15},{"imageOffset":980044,"symbol":"icu::Calendar::~Calendar()","symbolLocation":92,"imageIndex":15},{"imageOffset":1166656,"symbol":"icu::DateFormat::format(double, icu::UnicodeString&, icu::FieldPosition&) const","symbolLocation":408,"imageIndex":15},{"imageOffset":2301452,"symbol":"udat_format","symbolLocation":352,"imageIndex":15},{"imageOffset":560704,"symbol":"CFDateFormatterCreateStringWithAbsoluteTime","symbolLocation":192,"imageIndex":5},{"imageOffset":10026324,"symbol":"-[NSDateFormatter stringForObjectValue:]","symbolLocation":292,"imageIndex":6},{"imageOffset":88316,"sourceLine":77,"sourceFile":"DebugLogger.swift","symbol":"closure #1 in DebugLogger.log(_:file:function:line:level:)","imageIndex":0,"symbolLocation":660},{"imageOffset":90672,"sourceFile":"\/<compiler-generated>","symbol":"partial apply for closure #1 in DebugLogger.log(_:file:function:line:level:)","symbolLocation":60,"imageIndex":0},{"imageOffset":91076,"sourceFile":"\/<compiler-generated>","symbol":"thunk for @escaping @callee_guaranteed @Sendable () -> ()","symbolLocation":48,"imageIndex":0},{"imageOffset":7004,"symbol":"_dispatch_call_block_and_release","symbolLocation":32,"imageIndex":12},{"imageOffset":113348,"symbol":"_dispatch_client_callout","symbolLocation":16,"imageIndex":12},{"imageOffset":42216,"symbol":"_dispatch_lane_serial_drain","symbolLocation":740,"imageIndex":12},{"imageOffset":44996,"symbol":"_dispatch_lane_invoke","symbolLocation":388,"imageIndex":12},{"imageOffset":87156,"symbol":"_dispatch_root_queue_drain_deferred_wlh","symbolLocation":292,"imageIndex":12},{"imageOffset":85356,"symbol":"_dispatch_workloop_worker_thread","symbolLocation":692,"imageIndex":12},{"imageOffset":11852,"symbol":"_pthread_wqthread","symbolLocation":292,"imageIndex":13},{"imageOffset":7068,"symbol":"start_wqthread","symbolLocation":8,"imageIndex":13}]},{"id":10373997,"frames":[],"threadState":{"x":[{"value":6137819136},{"value":146459},{"value":6137282560},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6137819136},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10375426,"name":"AudioSession - RootQueue","threadState":{"x":[{"value":14},{"value":4294967115611373572},{"value":999999958},{"value":68719460488},{"value":50871866944},{"value":6835597824},{"value":0},{"value":0},{"value":999999958},{"value":3},{"value":13835058055282163714},{"value":80000000},{"value":54489648797499742},{"value":54472054463969560},{"value":180224},{"value":26},{"value":18446744073709551578},{"value":8389600392},{"value":0},{"value":2388325515260},{"value":50881385408},{"value":1000000000},{"value":50881385272},{"value":6138392800},{"value":0},{"value":0},{"value":18446744071411073023},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6542728324},"cpsr":{"value":2147483648},"fp":{"value":6138392384},"sp":{"value":6138392352},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059336},"far":{"value":0}},"frames":[{"imageOffset":3016,"symbol":"semaphore_timedwait_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":224388,"symbol":"_dispatch_sema4_timedwait","symbolLocation":64,"imageIndex":12},{"imageOffset":16136,"symbol":"_dispatch_semaphore_wait_slow","symbolLocation":76,"imageIndex":12},{"imageOffset":81344,"symbol":"_dispatch_worker_thread","symbolLocation":324,"imageIndex":12},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]},{"id":10375437,"frames":[],"threadState":{"x":[{"value":6139539456},{"value":146691},{"value":6139002880},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6139539456},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10375438,"frames":[],"threadState":{"x":[{"value":6140112896},{"value":152835},{"value":6139576320},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6140112896},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10375439,"frames":[],"threadState":{"x":[{"value":6141259776},{"value":146947},{"value":6140723200},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6141259776},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10375440,"frames":[],"threadState":{"x":[{"value":6141833216},{"value":147203},{"value":6141296640},{"value":0},{"value":409604},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6141833216},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10375441,"frames":[],"threadState":{"x":[{"value":6142406656},{"value":0},{"value":6141870080},{"value":0},{"value":278532},{"value":18446744073709551615},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0},{"value":0}],"flavor":"ARM_THREAD_STATE64","lr":{"value":0},"cpsr":{"value":0},"fp":{"value":0},"sp":{"value":6142406656},"esr":{"value":0},"pc":{"value":6544313236},"far":{"value":0}}},{"id":10377219,"name":"com.apple.audio.IOThread.client","threadState":{"x":[{"value":14},{"value":158355},{"value":0},{"value":0},{"value":0},{"value":16},{"value":4484476304},{"value":2},{"value":1},{"value":4255357573735973000},{"value":3298534884096},{"value":3298534884098},{"value":48},{"value":9600},{"value":13},{"value":4479796624},{"value":18446744073709551579},{"value":8389600416},{"value":0},{"value":50883432248},{"value":50883432240},{"value":50883432272},{"value":1},{"value":50921632736},{"value":12},{"value":0},{"value":6603101947},{"value":50883432240},{"value":50883431424}],"flavor":"ARM_THREAD_STATE64","lr":{"value":6751956904},"cpsr":{"value":1610612736},"fp":{"value":6136098048},"sp":{"value":6136098032},"esr":{"value":1442840704,"description":"(Syscall)"},"pc":{"value":6544059324},"far":{"value":0}},"frames":[{"imageOffset":3004,"symbol":"semaphore_wait_signal_trap","symbolLocation":8,"imageIndex":11},{"imageOffset":126888,"symbol":"caulk::mach::semaphore::wait_signal_or_error(caulk::mach::semaphore&)","symbolLocation":36,"imageIndex":14},{"imageOffset":2122372,"symbol":"HALC_ProxyIOContext::IOWorkLoop()","symbolLocation":5052,"imageIndex":17},{"imageOffset":2115616,"symbol":"invocation function for block in HALC_ProxyIOContext::HALC_ProxyIOContext(unsigned int, unsigned int)","symbolLocation":172,"imageIndex":17},{"imageOffset":4006592,"symbol":"HALC_IOThread::Entry(void*)","symbolLocation":88,"imageIndex":17},{"imageOffset":27656,"symbol":"_pthread_start","symbolLocation":136,"imageIndex":13},{"imageOffset":7080,"symbol":"thread_start","symbolLocation":8,"imageIndex":13}]}],
  "usedImages" : [
  {
    "source" : "P",
    "arch" : "arm64",
    "base" : 4334780416,
    "size" : 753664,
    "uuid" : "35e96ff1-979e-31e0-a805-4b0a98ef18ec",
    "path" : "*\/LocalDictation.app\/Contents\/MacOS\/LocalDictation",
    "name" : "LocalDictation"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4482826240,
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
    "base" : 4480221184,
    "size" : 49152,
    "uuid" : "f8bd9069-8c4f-37ea-af9a-2b1060f54e4f",
    "path" : "\/usr\/lib\/libobjc-trampolines.dylib",
    "name" : "libobjc-trampolines.dylib"
  },
  {
    "source" : "P",
    "arch" : "arm64e",
    "base" : 4679122944,
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
    "base" : 6608130048,
    "size" : 2955290,
    "uuid" : "ec990bc7-956f-300a-8870-118269cb7e73",
    "path" : "\/usr\/lib\/libicucore.A.dylib",
    "name" : "libicucore.A.dylib"
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
  }
],
  "sharedCache" : {
  "base" : 6539247616,
  "size" : 5609635840,
  "uuid" : "b69ff43c-dbfd-3fb1-b4fe-a8fe32ea1062"
},
  "vmSummary" : "ReadOnly portion of Libraries: Total=1.8G resident=0K(0%) swapped_out_or_unallocated=1.8G(100%)\nWritable regions: Total=173.1M written=2129K(1%) resident=641K(0%) swapped_out=1488K(1%) unallocated=171.0M(99%)\n\n                                VIRTUAL   REGION \nREGION TYPE                        SIZE    COUNT (non-coalesced) \n===========                     =======  ======= \nAccelerate framework               256K        2 \nActivity Tracing                   256K        1 \nAttributeGraph Data               1024K        1 \nCG image                           192K        9 \nColorSync                           16K        1 \nCoreAnimation                     3392K      108 \nCoreGraphics                       112K        7 \nCoreUI image data                  320K        3 \nFoundation                         912K       11 \nImage IO                            64K        4 \nKernel Alloc Once                   32K        1 \nMALLOC                           147.4M       31 \nMALLOC guard page                 4112K        4 \nSTACK GUARD                       56.3M       18 \nStack                             17.0M       18 \nVM_ALLOCATE                        464K       20 \nVM_ALLOCATE (reserved)             768K        1         reserved VM address space (unallocated)\n__AUTH                            5803K      642 \n__AUTH_CONST                      88.5M     1023 \n__CTF                               824        1 \n__DATA                            29.8M      974 \n__DATA_CONST                      32.8M     1032 \n__DATA_DIRTY                      8768K      885 \n__FONT_DATA                        2352        1 \n__INFO_FILTER                         8        1 \n__LINKEDIT                       595.2M        5 \n__OBJC_RO                         78.3M        1 \n__OBJC_RW                         2567K        1 \n__TEXT                             1.2G     1055 \n__TPRO_CONST                       128K        2 \nmapped file                      493.9M       43 \npage table in kernel               641K        1 \nshared memory                     2496K       16 \n===========                     =======  ======= \nTOTAL                              2.7G     5923 \nTOTAL, minus reserved VM space     2.7G     5923 \n",
  "legacyInfo" : {
  "threadTriggered" : {
    "queue" : "com.apple.main-thread"
  }
},
  "logWritingSignature" : "8564c4b5ffabbed46350c188afda369b72176c24",
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

