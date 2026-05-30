class AiSeverityClassifier
  CRITICAL_WORDS = %w[emergency death accident violence hospital].freeze
  HIGH_WORDS = %w[road electricity water police].freeze
  MEDIUM_WORDS = %w[pension scheme document].freeze

  def initialize(request)
    @text = [
      request.category,
      request.request_title,
      request.description
    ].compact.join(" ").downcase
  end

  def call
    return :critical if CRITICAL_WORDS.any? { |word| @text.include?(word) }
    return :high if HIGH_WORDS.any? { |word| @text.include?(word) }
    return :medium if MEDIUM_WORDS.any? { |word| @text.include?(word) }

    :low
  end
end
