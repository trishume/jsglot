require 'polyglot'
require 'v8'
module JsGlot
  @context = V8::Context.new
  @context['puts'] = method(:puts)
  @context['wrapmethod'] = lambda do |methodname|
    meth_sym = methodname.to_sym
    @context[meth_sym] = method(meth_sym)
  end
  def self.load(fname)
    @context.load(fname)
  end
  def self.call(sym, *args, &block)
    fcn = @context[sym]
    return fcn.send :call, *args, &block
  end
  def self.wrapmethod(method)
    meth_sym = method.to_sym
    $V8_CXT[meth_sym] = method(:meth_sym)
  end
  def self.method_missing(sym, *args, &block)
    fcn = @context[sym]
    return fcn.send :call, *args, &block
  end
end

class JsglotLoader
    def self.load(filename, options = nil, &block)
        JsGlot.load(filename)
    end
end
Polyglot.register("js", JsglotLoader)