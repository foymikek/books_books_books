require "minitest/autorun"
require "minitest/pride"
require "./lib/book"
require "./lib/author"
require "./lib/library"

class LibraryTest < Minitest::Test

  def test_it_has_attributes
    dpl = Library.new("Denver Public Library")

    assert_equal "Denver Public Library", dpl.name
    assert_equal [], dpl.books
    assert_equal [], dpl.authors
  end

  def test_library_can_add_author
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})

    assert_equal [], dpl.authors

    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    assert_equal [charlotte_bronte, harper_lee], dpl.authors
  end

  def test_library_can_add_book
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    professor = charlotte_bronte.write("The Professor", "1857")
    villette = charlotte_bronte.write("Villette", "1853")

    assert_equal [], dpl.books

    dpl.add_book(jane_eyre)
    dpl.add_book(professor)
    dpl.add_book(villette)

    assert_equal [jane_eyre, professor, villette], dpl.books
  end

  def test_publication_time_frame_for_author
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    professor = charlotte_bronte.write("The Professor", "1857")
    villette = charlotte_bronte.write("Villette", "1853")
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)
    charlotte_bronte.add_book(jane_eyre)
    charlotte_bronte.add_book(professor)
    charlotte_bronte.add_book(villette)
    harper_lee.add_book(mockingbird)
    dpl.add_book(jane_eyre)
    dpl.add_book(professor)
    dpl.add_book(villette)
    dpl.add_book(mockingbird)

    assert_equal [charlotte_bronte, harper_lee], dpl.authors
    assert_equal [jane_eyre, professor, villette, mockingbird], dpl.books
    expected = {:start=>"1847", :end=>"1857"}
    assert_equal expected, dpl.publication_time_frame_for(charlotte_bronte)
    expected = {:start=>"1960", :end=>"1960"}
    assert_equal expected, dpl.publication_time_frame_for(harper_lee)
  end

  def test_library_checkout
    skip
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853")
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")

    assert_equal false, dpl.checkout(mockingbird)
    assert_equal false, dpl.checkout(jane_eyre)
  end

  def test_checked_out_books
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853")
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    assert dpl.checkout(jane_eyre)
    assert_equal [jane_eyre], dpl.checked_out_books
  end

  def test_return
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853")
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    assert dpl.checkout(jane_eyre)
    assert_equal false, dpl.checkout(jane_eyre)

    dpl.return(jane_eyre)

    assert_equal [], dpl.checked_out_books

    assert dpl.checkout(jane_eyre)
    assert dpl.checkout(villette)
    assert_equal [jane_eyre, villette], dpl.checked_out_books
    assert dpl.checkout(mockingbird)

    dpl.return(mockingbird)

    assert dpl.checkout(mockingbird)

    dpl.return(mockingbird)

    assert dpl.checkout(mockingbird)
  end

  def test_most_popular_book
    dpl = Library.new("Denver Public Library")
    charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    jane_eyre = charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    villette = charlotte_bronte.write("Villette", "1853")
    harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    mockingbird = harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
    dpl.add_author(charlotte_bronte)
    dpl.add_author(harper_lee)

    assert dpl.checkout(jane_eyre)
    assert_equal false, dpl.checkout(jane_eyre)

    dpl.return(jane_eyre)

    assert_equal [], dpl.checked_out_books

    assert dpl.checkout(jane_eyre)
    assert dpl.checkout(villette)
    assert_equal [jane_eyre, villette], dpl.checked_out_books
    assert dpl.checkout(mockingbird)

    dpl.return(mockingbird)

    assert dpl.checkout(mockingbird)

    dpl.return(mockingbird)

    assert dpl.checkout(mockingbird)
    assert_equal mockingbird, dpl.most_popular_book
  end
end
