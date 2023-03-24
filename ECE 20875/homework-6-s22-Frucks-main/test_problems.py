import problems
import unittest


class TestProblem1(unittest.TestCase):
    def test_correct_format_1(self):
        self.assertIs(problems.problem1('+1 (765) 494-4600'), True)

    def test_correct_format_2(self):
        self.assertIs(problems.problem1('+1 765-494-4600'), True)

    def test_mexico_country_code(self):
        self.assertIs(problems.problem1('+52 765-494-4600'), True)

    def test_correct_format_3(self):
        self.assertIs(problems.problem1('494-4600'), True)

    def test_incorrect_format_3(self):
        self.assertIs(problems.problem1('+1 494-4600'), False,
                      'A 7 digit phone number cannot have a country code')

    def test_wrong_country_code(self):
        self.assertIs(problems.problem1('+7 765-494-4600'), False,
                      'The only valid country codes are +1 and +52')

    def test_no_country_code(self):
        self.assertIs(problems.problem1('765-494-4600'), False,
                      'A country code is required for a 10 digit number.')

    def test_leading_trailing_spaces(self):
        self.assertIs(problems.problem1(' +1 765-494-4600 '), False,
                      'Spaces before or after are invalid.')

    def test_incorrect_format(self):
        self.assertIs(problems.problem1('+1 (765) 494 4600'), False,
                      '`(XXX) XXX XXXX` is not a valid format.')

    def test_only_numbers(self):
        self.assertIs(problems.problem1('+1 123-4a6-7890'), False,
                      'A phone number can only contain digits.')

    def test_incorrect_format_1(self):
        self.assertIs(problems.problem1('+1 (765)-494-4600'), False,
                      '`(XXX)-XXX-XXXX` is not a valid format.')


class TestProblem2(unittest.TestCase):
    def test_simple_valid_streetname(self):
        self.assertEqual(
            problems.problem2('465 Northwestern Ave.'), '465 Northwestern',
            'The street name in `465 Northwestern Ave.` is `Northwestern`.')

    def test_simple_valid_streetname(self):
        self.assertEqual(problems.problem2('1 abc St. 1 Abc St.'), '1 Abc',
                         'The street name must start with a capital letter.')

    def test_multiple_word_streetname(self):
        self.assertEqual(problems.problem2('201 South First St.'),
                         '201 South First', 'Street names can be multiple words.')

    def test_long_streetname(self):
        self.assertEqual(
            problems.problem2('1 Aa B C D E F St.'), '1 Aa B C D E F',
            'Words in street names don\'t need lowercase letters.')

    def test_incorrect_termination(self):
        self.assertEqual(problems.problem2('465 Northwestern Dry Dr.'),
                         '465 Northwestern Dry',
                         'Are you escaping all of your periods? Dry != Dr.')

    def test_words_at_front_and_back(self):
        self.assertEqual(
            problems.problem2('I am at 465 Northwestern Ave. for lunch.'),
            '465 Northwestern',
            'A street name can occur in the middle of a string!')

    def test_long_tricky(self):
        self.assertEqual(
            problems.problem2(
                '123 Mayb3 Y0u 222 Did not th1nk 333 This Through Rd. Did Y0u Ave.'
            ), '333 This Through',
            'The only valid street name, by the rules given, is `This Through`.'
        )


class TestProblem3(unittest.TestCase):
    def test_simple_garble(self):
        self.assertEqual(problems.problem3('465 Northwestern Ave.'),
                         '465 nretsewhtroN Ave.',
                         'Are you correctly detecting the street name?')

    def test_only_street_name_reversed(self):
        self.assertEqual(problems.problem3('Go West on 999 West St.'),
                         'Go West on 999 tseW St.',
                         'Only the street name should be reversed!')

    def test_multiple_words_reversed(self):
        self.assertEqual(
            problems.problem3('Meet me at 201 South First St. at noon'),
            'Meet me at 201 tsriF htuoS St. at noon',
            'A street name with multiple words should be reversed.')


if __name__ == '__main__':
    print('Reminder, these test cases are NOT exhaustive.')
    print('Passing these cases does not guarantee you will get full credit.')
    unittest.main()
