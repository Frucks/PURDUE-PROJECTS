import numpy as np
from helper import remove_punc
from hw8_1 import *
from nltk.stem import PorterStemmer, WordNetLemmatizer
import nltk
from nltk.corpus import stopwords
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('wordnet')
import numpy as np
import os
hw8_path = '/home/shay/a/jtafffre/homework-8-s22-Frucks'
os.chdir(hw8_path)

#Clean and prepare the contents of a document
#Takes in a file name to read in and clean
#Return a single string, without stopwords, spaces, and punctuation
# NOTE: Do not append any directory names to doc -- assume we will give you
# a string representing a file name that will open correctly
def read_and_clean_doc(doc) :
    #1. Open document, read text into *single* string
    with open(doc, "r") as myfile:
        raw = myfile.read()
    #2. Filter out punctuation from list of words (use remove_punc)
    nopunc = remove_punc(raw)
    #3. Make the words lower case
    lower_nopunc = nopunc.lower()
    #4. Filter out stopwords
    stop_words = list(set(stopwords.words('english')))
    split_lower_nopunc = lower_nopunc.split()
    filtered = []
    for word in split_lower_nopunc:
        if word not in stop_words:
            filtered.append(word)
    #5. Remove remaining whitespace
    all_no_stop = ''.join(filtered)

    return all_no_stop

#Builds a doc-word matrix for a set of documents
#Takes in a *list of filenames* and a number *n* corresponding to the length of each ngram
#
#Returns 1) a doc-word matrix for the cleaned documents
#This should be a 2-dimensional numpy array, with one row per document and one 
#column per ngram (there should be as many columns as unique words that appear
#across *all* documents. Also, Before constructing the doc-word matrix, 
#you should sort the list of ngrams output and construct the doc-word matrix based on the sorted list
#
#Also returns 2) a list of ngrams that should correspond to the columns in
#docword
def build_doc_word_matrix(doclist, n) :
    #1. Create the cleaned string for each doc (use read_and_clean_doc)
    all_ngrams = [get_ngrams(i, n) for i in [read_and_clean_doc(document) for document in doclist]]
    ngram_set = set()
    [ngram_set.update(ngram) for ngram in all_ngrams] 
    ngramlist = sorted(list(ngram_set))

    #2. Create and use ngram lists to build the doc word matrix
    docword = np.zeros((len(doclist), len(ngramlist)))
    for k in range(len(doclist)):
        doc_string = [read_and_clean_doc(document) for document in doclist][k]
        ngrams = []
        [ngrams.append(doc_string[string:string + n]) for string in range(len(doc_string) - n + 1)]
        for ngrm in ngrams:
            docword[k, ngramlist.index(ngrm)] += 1

    return docword, ngramlist

#Builds a term-frequency matrix
#Takes in a doc word matrix (as built in build_doc_word_matrix)
#Returns a term-frequency matrix, which should be a 2-dimensional numpy array
#with the same shape as docword
def build_tf_matrix(docword) :
    
    #fill in

    sum = np.sum(docword, axis=1)
    tf = docword / (sum[:,np.newaxis])
    return tf
    
#Builds an inverse document frequency matrix
#Takes in a doc word matrix (as built in build_doc_word_matrix)
#Returns an inverse document frequency matrix (should be a 1xW numpy array where
#W is the number of ngrams in the doc word matrix)
#Don't forget the log factor!
def build_idf_matrix(docword):

    #fill in

    idf = docword.shape[0]
    idf = idf / (np.sum(docword > 0, axis=0).reshape(1, -1))

    return np.log10(idf)


    
#Builds a tf-idf matrix given a doc word matrix
def build_tfidf_matrix(docword):

    #fill in

    tfidf = build_tf_matrix(docword) * build_idf_matrix(docword)

    return tfidf
    
#Find the three most distinctive ngrams, according to TFIDF, in each document
#Input: a docword matrix, a wordlist (corresponding to columns) and a doclist 
# (corresponding to rows)
#Output: a dictionary, mapping each document name from doclist to an (ordered
# list of the three most unique ngrams in each document
def find_distinctive_ngrams(docword, ngramlist, doclist) :
    distinctive_words = {}
    #fill in
    #you might find numpy.argsort helpful for solving this problem:
    #https://docs.scipy.org/doc/numpy/reference/generated/numpy.argsort.html
    
    for word in range(len(doclist)):
        tfidf = build_tfidf_matrix(docword)
        sort = np.argsort(-tfidf[word, :])[:3]
        array = list(np.array(ngramlist)[sort])
        distinctive_words[doclist[word]] = array

    return distinctive_words


if __name__ == '__main__':
    from os import listdir
    from os.path import isfile, join, splitext
    #Some main code:
    '''directory='lecs'
    path = join(directory, '1_vidText.txt')
    read_and_clean_doc(path)
    #build document list
    
    path='lecs'
    file_list = [f for f in listdir(path) if isfile(join(path, f))]
    path_list = [join(path, f) for f in file_list]
    
    mat,wlist=build_doc_word_matrix(path_list)
    
    tfmat = build_tf_matrix(mat)
    idfmat = build_idf_matrix(mat)
    tfidf = build_tfidf_matrix(mat)
    results = find_distinctive_words(mat,wlist,file_list)'''
    
    ### Test Cases ###
    directory='lecs'
    path1 = join(directory, '1_vidText.txt')
    path2 = join(directory, '2_vidText.txt')
    
    
    print("*** Testing read_and_clean_doc ***")
    print(read_and_clean_doc(path1)[0:20])
    print("*** Testing build_doc_word_matrix ***") 
    doclist =[path1, path2]
    docword, wordlist = build_doc_word_matrix(doclist, 3)
    print(docword.shape)
    print(len(wordlist))
    print(docword[0][0:10])
    print(wordlist[0:10])
    print(docword[1][0:10])
    print("*** Testing build_tf_matrix ***") 
    tf = build_tf_matrix(docword)
    print(tf[0][0:10])
    print(tf[1][0:10])
    print(tf.sum(axis =1))
    print("*** Testing build_idf_matrix ***") 
    idf = build_idf_matrix(docword)
    print(idf[0][0:10])
    print("*** Testing build_tfidf_matrix ***") 
    tfidf = build_tfidf_matrix(docword)
    print(tfidf.shape)
    print(tfidf[0][0:10])
    print(tfidf[1][0:10])
    print("*** Testing find_distinctive_words ***")
    print(find_distinctive_ngrams(docword, wordlist, doclist))
