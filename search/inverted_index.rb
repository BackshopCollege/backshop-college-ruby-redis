require 'test/unit'



module DocumentFactory
  
  def create_document(text)
    doc = Document.new(text)
    doc.save
    doc
  end
end

class FullTextSearch < Test::Unit::TestCase
  include DocumentFactory

  def setup

    @gym_haters_text = create_document('Today I will go to the Gym. Really, I can\'t stand weight lifting. I love Redis.')
    @my_bio          = create_document('Thiago Teixeira Dantas will show you some naive inverted index attempt using redis. Are you READY ?')

    FullText.index(:documents) do |index| 
      index.analyze @gym_haters_text
      index.analyze @my_bio
    end

  end

  def teardown
    FullText.clear(:documents)
  end

  def test_number_of_indexed_documents
    assert_equal 2, FullText.indexed_documents
  end

  def test_make_indexed_text_searchable_like_OR_expression
    documents = FullText.search 'naive inverted'
    assert_equal 1, documents.length
  end

  def test_searching_ignoring_case
    documents = FullText.search 'ready'
    assert_equal 1, documents.length
    assert_equal @my_bio, documents.first
  end

  def test_ranking_texts
    documents = FullText.search 'redis thiago'
    assert_equal 2, documents.length
    assert_equal @my_bio, documents.first
    assert_equal @gym_haters_text, documents.last
  end

  # It's your duty create the lasts two tests
  def test_ignoring_accent
  end


  def test_stemming
  end

end