def exponent_map(n):
    """
    Returns a new function f. f should take in a list L and computes x^n over every element x in L, returning the new list after exponentiation
    :param n: exponent
    :return: function
    """
    # Fill in

    def f(L):
        
        expo = []

        for x in L:
            expo.append(x ** n)

        return expo

    return f

    pass

def compose_map(fun1, fun2, L):
    """
    Returns a new list r where each element in r is fun2(fun1(i)) for the
    corresponding element i in L
    :param fun1: function
    :param fun2: function
    :param L: list
    :return: list
    """
    # Fill in

    comp = []

    for i in L:
        comp.append(fun2(fun1(i)))

    return comp

    pass


def compose(fun1, fun2):
    # Fill in
    """
    Returns a new function f. f should take a single input i, and return
    fun1(fun2(i))
    :param fun1: function
    :param fun2: function
    :return: function
    """
    def ret_fun(i):
        # Fill in

        return fun1(fun2(i))
        pass

    return ret_fun


def repeater(fun, num_repeats):
    """
    Returns a new function f. f should take a single input , and returnx
    fun applied to x num_repeats times. In other words, if num_repeats is 1, f
    should return fun(x). If num_repeats is 2, f should return fun(fun(x)). If
    num_repeats is 0, f should return x.
    :param fun: function
    :param num_repeats: int
    :return: function
    """
    def ret_fun(x):
        # Fill in
        f = fun(x)

        if num_repeats == 0:
            return x

        for k in range(num_repeats - 1):
            f = fun(f)

        return f
        pass

    return ret_fun


if __name__ == '__main__':

    def test1(x):
        return x * 2

    def test2(x):
        return x - 3

    data = [2, 5, -10, -7, -7, -3, -1, 9, 8, -6]
    
    f1 = exponent_map(2)
    print(f1(data))

    print(compose_map(test1, test2, data))
    print(compose_map(test2, test1, data))

    f2 = compose(test1, test2)

    print(f2(4))

    print(list(map(f2, data)))

    f3 = compose(test2, test1)

    print(f3(4))

    print(list(map(f3, data)))

    z = repeater(test1, 0)
    once = repeater(test1, 1)
    twice = repeater(test1, 2)
    thrice = repeater(test1, 3)

    print("repeat 0 times: {}".format(z(5)))
    print("repeat 1 time: {}".format(once(5)))
    print("repeat 2 times: {}".format(twice(5)))
    print("repeat 3 times: {}".format(thrice(5)))
