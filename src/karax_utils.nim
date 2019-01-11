import macros
import future


macro curry*(f: typed, args: varargs[untyped]): untyped = # ,

  # echo f.treeRepr
  # echo args.treeRepr

  # echo f.getType.treeRepr
  # echo f.getTypeInst.treeRepr
  # echo f.getTypeImpl.treeRepr

  var tTypeImpl = f.getTypeImpl
  # echo tTypeImpl.len
  # echo tTypeImpl.kind
  # echo tTypeImpl.typeKind
  # echo tTypeImpl.treeRepr

  if tTypeImpl.typeKind != ntyProc:
    error "curry requires a proc as its first argument, but received: " & f.repr &
          " which has typeKind " & $tTypeImpl.typeKind

  # we need the FormalParams which are the first child
  let formalParams = tTypeImpl[0]

  # and we have to iterate its childred starting at 1
  # because child 0 is the return type
  let returnType = formalParams[0]
  # echo returnType.treeRepr

  var params = @[
    returnType,
  ]

  var call = newCall(f)
  for arg in args:
    call.add(arg)

  for i in (1 + args.len) ..< formalParams.len:
    let child = formalParams[i]
    # echo child.treeRepr
    if child.kind != nnkIdentDefs:
      error "Function parameters are expected to be IdentDefs, but received: " & child.repr &
          " which has typeKind " & $child.kind
    else:
      let nameIdent = newIdentNode($child[0])
      let typeIdent = newIdentNode($child[1])
      params.add(newIdentDefs(name = nameIdent, kind = typeIdent))
      call.add(newIdentNode($child[0]))

  let body = newStmtList(call)

  result = newProc(params=params, body=body, procType=nnkLambda)
  # echo result.treeRepr


proc reduce*[T](s: seq[T], f: (T, T) -> T): T =
  result = T(0)
  for x in s:
    result = f(result, x)
