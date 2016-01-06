should = require 'should'
scan = require '../scanner'
error = require '../error'
{inspect: i} = require 'util'

describe 'The scanner', ->

  it 'scans the simplest program', (done) ->
    scan 'test/data/good-programs/hello.iki', (tokens) ->
      tokens.length.should.equal 4
      i(tokens[0]).should.equal i {kind:'write',lexeme:'write',line:1,col:1}
      i(tokens[1]).should.equal i {kind:'intlit',lexeme:'0',line:1,col:7}
      i(tokens[2]).should.equal i {kind:';',lexeme:';',line:1,col:8}
      i(tokens[3]).should.equal i {kind:'EOF',lexeme:'EOF'}
      done()

  it 'properly handles comments and blank lines', (done) ->
    scan 'test/data/token-tests/comments-and-blank-lines', (tokens) ->
      tokens.length.should.equal 4
      i(tokens[0]).should.equal i {kind:'var',lexeme:'var',line:1,col:1}
      i(tokens[1]).should.equal i {kind:'id',lexeme:'x',line:3,col:3}
      i(tokens[2]).should.equal i {kind:';',lexeme:';',line:5,col:7}
      i(tokens[3]).should.equal i {kind:'EOF',lexeme:'EOF'}
      done()

  it 'reads symbolic tokens properly', (done) ->
    scan 'test/data/token-tests/symbols', (tokens) ->
      i(tokens[0]).should.equal i {kind:'<=',lexeme:'<=',line:1,col:1}
      i(tokens[1]).should.equal i {kind:'<',lexeme:'<',line:1,col:3}
      i(tokens[2]).should.equal i {kind:',',lexeme:',',line:1,col:4}
      i(tokens[3]).should.equal i {kind:'==',lexeme:'==',line:1,col:5}
      i(tokens[4]).should.equal i {kind:'=',lexeme:'=',line:1,col:7}
      i(tokens[5]).should.equal i {kind:'>=',lexeme:'>=',line:1,col:8}
      i(tokens[6]).should.equal i {kind:'>',lexeme:'>',line:1,col:10}
      i(tokens[7]).should.equal i {kind:'!=',lexeme:'!=',line:1,col:11}
      i(tokens[8]).should.equal i {kind:':',lexeme:':',line:1,col:13}
      i(tokens[9]).should.equal i {kind:';',lexeme:';',line:1,col:14}
      i(tokens[10]).should.equal i {kind:'(',lexeme:'(',line:1,col:15}
      i(tokens[11]).should.equal i {kind:')',lexeme:')',line:1,col:16}
      done()

  it 'distinguishes reserved words and identifiers', (done) ->
    scan 'test/data/token-tests/words', (tokens) ->
      i(tokens[0]).should.equal i {kind:'id',lexeme:'whilexy',line:1,col:1}
      i(tokens[1]).should.equal i {kind:'while',lexeme:'while',line:1,col:9}
      i(tokens[2]).should.equal i {kind:'id',lexeme:'whil',line:1,col:15}
      i(tokens[3]).should.equal i {kind:'end',lexeme:'end',line:1,col:20}
      i(tokens[4]).should.equal i {kind:'loop',lexeme:'loop',line:1,col:24}
      i(tokens[5]).should.equal i {kind:'var',lexeme:'var',line:1,col:29}
      i(tokens[6]).should.equal i {kind:'and',lexeme:'and',line:1,col:33}
      i(tokens[7]).should.equal i {kind:'or',lexeme:'or',line:1,col:37}
      i(tokens[8]).should.equal i {kind:'id',lexeme:'ore',line:1,col:40}
      i(tokens[9]).should.equal i {kind:'not',lexeme:'not',line:1,col:44}
      i(tokens[11]).should.equal i {kind:'id',lexeme:'intbool',line:1,col:48}
      i(tokens[13]).should.equal i {kind:'int',lexeme:'int',line:1,col:56}
      i(tokens[15]).should.equal i {kind:'bool',lexeme:'bool',line:1,col:60}
      i(tokens[17]).should.equal i {kind:'read',lexeme:'read',line:1,col:65}
      i(tokens[19]).should.equal i {kind:'write',lexeme:'write',line:1,col:70}
      i(tokens[21]).should.equal i {kind:'true',lexeme:'true',line:1,col:76}
      i(tokens[23]).should.equal i {kind:'false',lexeme:'false',line:1,col:81}
      done()

  it 'scans numbers properly', (done) ->
    scan 'test/data/token-tests/numbers', (tokens) ->
      tokens.length.should.equal 7
      i(tokens[0]).should.equal i {kind:'id',lexeme:'loop89x7',line:1,col:1}
      i(tokens[1]).should.equal i {kind:'-',lexeme:'-',line:1,col:9}
      i(tokens[2]).should.equal i {kind:'intlit',lexeme:'222289',line:1,col:10}
      i(tokens[3]).should.equal i {kind:'id',lexeme:'while9',line:1,col:16}
      i(tokens[4]).should.equal i {kind:'intlit',lexeme:'02',line:1,col:23}
      i(tokens[5]).should.equal i {kind:'id',lexeme:'русский',line:1,col:25}
      i(tokens[6]).should.equal i {kind:'EOF',lexeme:'EOF'}
      done()

  it 'detects illegal characters', (done) ->
    scan 'test/data/token-tests/illegal-char', (tokens) ->
      error.count.should.equal 1
      done()
