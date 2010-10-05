# search.rb
require 'rubygems'
require 'sinatra'
require 'tempfile'


NDB = Dir.pwd + '/db/nucleotide/Sinvicta2-2-3.cdna.subset.fasta'
PDB = Dir.pwd + '/db/protein/Sinvicta2-2-3.prot.subset.fasta'


get '/' do
  erb :search
end

post '/' do
  method = params[ :method ]
  raise IOError, 'Blast is not correctly installed! Cannot execute: ' + method if !commandExists?(method)

  puts params[ :database ]
  database = if params[ :database ] == 'protein'
               PDB
             elsif params[ :database ] == 'nucleotide'
               NDB
             end

  tmp = Tempfile.new("seqfile")
  tmp.puts( params[ :sequence ] )
  tmp.close

  command = "#{method} -db #{database} -query #{tmp.path}"
  puts "Will execute: " +command
  report = `#{command}`

  tmp.delete
  report
end


def commandExists?(command)
  system("which #{command} > /dev/null 2>/dev/null")
  return false if $?.exitstatus == 127
  return true
end