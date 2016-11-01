# Parser module
#
#   parse = require './parser'
#   program = parse sourceCodeString

Program = require './entities/program'
Block = require './entities/block'
Type = require './entities/type'
VariableDeclaration = require './entities/variabledeclaration'
AssignmentStatement = require './entities/assignmentstatement'
ReadStatement = require './entities/readstatement'
WriteStatement = require './entities/writestatement'
WhileStatement = require './entities/whilestatement'
IntegerLiteral = require './entities/integerliteral'
BooleanLiteral = require './entities/booleanliteral'
VariableReference = require './entities/variablereference'
BinaryExpression = require './entities/binaryexpression'
UnaryExpression = require './entities/unaryexpression'
ohm = require 'ohm-js'
fs = require 'fs'

grammar = ohm.grammar(fs.readFileSync('./iki.ohm'))

semantics = grammar.createSemantics().addOperation('ast', {
  Program: (b) -> new Program(b.ast())
  Block: (s, _) -> new Block(s.ast())
  Stmt_decl: (v, id, _, type) -> new VariableDeclaration(id.sourceString, type.ast())
  Stmt_assignment: (id, _, exp) -> new AssignmentStatement(id.ast(), exp.ast())
  Stmt_read: (r, i, c, more) -> new ReadStatement([i.ast()].concat(more.ast()))
  Stmt_write: (w, e, c, more) -> new WriteStatement([e.ast()].concat(more.ast()))
  Stmt_while: (w, e, d, b, _) -> new WhileStatement(e.ast(), b.ast())
  Type: (typeName) -> Type.forName typeName.sourceString
  Exp_binary: (e1, _, e2) -> new BinaryExpression("or", e1.ast(), e2.ast())
  Exp1_binary: (e1, _, e2) -> new BinaryExpression("and", e1.ast(), e2.ast())
  Exp2_binary: (e1, bop, e2) -> new BinaryExpression(bop.operator(), e1.ast(), e2.ast())
  Exp3_binary: (e1, bop, e2) -> new BinaryExpression(bop.operator(), e1.ast(), e2.ast())
  Exp4_binary: (e1, bop, e2) -> new BinaryExpression(bop.operator(), e1.ast(), e2.ast())
  Exp5_unary: (uop, e) -> new UnaryExpression(uop.operator(), e.ast())
  Exp6_parens: (l, e, r) -> e.ast()
  boollit: (b) -> new BooleanLiteral(this.sourceString)
  intlit: (i) -> new IntegerLiteral(this.sourceString)
  id: (l, r) -> new VariableReference(this.sourceString)
}).addOperation('operator', {
  prefixop: (_) -> this.sourceString
  mulop: (_) -> this.sourceString
  addop: (_) -> this.sourceString
  relop: (_) -> this.sourceString
})

module.exports = parse = (text) ->
  match = grammar.match text
  throw match.message if not match.succeeded()
  semantics(match).ast()

#console.log(parse("var x:int; write 2+7, -7, x; read y, z;u=false or y;").toString())
