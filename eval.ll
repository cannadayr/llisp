%object = type {
        i32,  ; Tag
        i8*   ; Value (may be bitcast, if it safely fits in a pointer)
}

%list = type {
      %object*,  ; Value (null on last element)
      %object*   ; Next node (null on last element)
}

define %object* @eval(%object* %obj) {
       %is_nil = icmp eq %object* %obj, null
       br i1 %is_nil, label %eval_nil, label %decode_obj

eval_nil:
       ret %object* null

decode_obj:
       %tagPtr = getelementptr %object* %obj, i32 0, i32 0
       %tag = load i32* %tagPtr

       %valPtr = getelementptr %object* %obj, i32 0, i32 1
       %val = load i8** %valPtr

       switch i32 %tag, label %finalize [ i32 0, label %eval_list
                                          i32 1, label %eval_string ]

eval_list:
       ret %object* null

eval_string:
       ret %object* %obj

finalize:
       ret %object* null
}
