; ModuleID = 'test.bc'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.Packet = type { i32, i32 }

@.str = private unnamed_addr constant [4 x i8] c"pkt\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @process(ptr noundef %p) #0 {
entry:
  %retval = alloca i32, align 4
  %p.addr = alloca ptr, align 8
  store ptr %p, ptr %p.addr, align 8
  %0 = load ptr, ptr %p.addr, align 8
  %src = getelementptr inbounds %struct.Packet, ptr %0, i32 0, i32 0
  %1 = load i32, ptr %src, align 4
  %add = add nsw i32 %1, 5
  %2 = load ptr, ptr %p.addr, align 8
  %src1 = getelementptr inbounds %struct.Packet, ptr %2, i32 0, i32 0
  store i32 %add, ptr %src1, align 4
  %3 = load ptr, ptr %p.addr, align 8
  %src2 = getelementptr inbounds %struct.Packet, ptr %3, i32 0, i32 0
  %4 = load i32, ptr %src2, align 4
  %cmp = icmp eq i32 %4, 10
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  store i32 0, ptr %retval, align 4
  br label %return

return:                                           ; preds = %if.end, %if.then
  %5 = load i32, ptr %retval, align 4
  ret i32 %5
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
entry:
  %p = alloca %struct.Packet, align 4
  call void @klee_make_symbolic(ptr noundef %p, i64 noundef 8, ptr noundef @.str)
  %call = call i32 @process(ptr noundef %p)
  ret i32 0
}

declare void @klee_make_symbolic(ptr noundef, i64 noundef, ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 16.0.6 (https://github.com/llvm/llvm-project.git 7cbf1a2591520c2491aa35339f227775f4d3adf6)"}
