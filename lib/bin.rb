class Bin
  include Enumerable
  include Comparable
  attr_reader :list
  attr_reader :size

  def initialize
    @list = []
    @size = 0
  end

  # Add (array of) partitions to this bin
  def add!(partitions)
    partitions.each do |partition|
      @list << partition
      @size += partition.op_optimized
    end
    self
  end

  def update_size!
    @size = @list.map {|partition| partition.op_optimized}.reduce(:+)
    self
  end

  def last
    @list.last
  end

  def total_sites
    if @list.empty?
      0
    else
      self.map {|partition| partition.sites.size}.reduce(:+)
    end
  end

  def to_s(option = "none")
    if option == "fill_level"
      "[size: #{@size}, partition: #{@list.size}, sites: #{self.total_sites}]"
    else
      string = "[size: #{@size}, partitions: "
      @list.each {|partition| string += "(#{partition.to_s}), "}
      if string.size > 1
        string[0..-3] + "]"
      else
        "[]"
      end
    end
  end

  def to_csv(hash)
    self.map {|partition| partition.to_csv(hash)}
  end

  def each(&block)
    @list.each do |partition|
      if block_given?
        block.call(partition)
      else
        yield partition
      end
    end
  end

  def <=> other
    self.size <=> other.size
  end

end

