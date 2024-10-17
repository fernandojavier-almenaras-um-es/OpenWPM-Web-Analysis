
import re
from typing import Set, List, Match

DOMAIN_REGEX: re.Pattern[str] = re.compile(r'^https?://([^/?#]+)')

def isFirstParty(url : str, top_url : str) -> bool:
    top_domain: re.Match[str] | None = DOMAIN_REGEX.search(top_url)
    if top_domain == None:
        return False
    
    return re.search(url, top_domain.group()) != None


def grepForKeywords(keywords : List[str],  s : str, escaped: bool = False) -> Set[str]:
    results : Set[str] = set()
    if escaped:
        for keyword in keywords:
            if re.search(keyword, s) != None:
                results.add(keyword)
    else:
        for keyword in keywords:
            if re.search(re.escape(keyword), s) != None:
                results.add(keyword)
    return results

# un-escape characters escaped via any of the three methods:
# \xXX                                                       i.e.    \x4E = N          \x21 = !
# \uXXXX                                                     i.e.    \u265A = ♚        \u269B = ⚛
# \u{X} \u{XX} \u{XXX} \u{XXXX} \u{XXXXXX} \u{XXXXXX}        i.e.    \u{1F603} = 😃     \u{20457}= 𠑗 
# 
# source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String#escape_sequences
def unescapeString(s : str) -> str:
    pattern : str = r"\\x[a-fA-F0-9]{2}|\\u[a-fA-F0-9]{4}|\\u\{[a-fA-F0-9]{1,6}\}"
    return re.sub(pattern, replacement_function, s)


def replacement_function(m : Match[str] ) -> str:
    s : str = m.string[m.start(0):m.end(0)]
    if s[1] == 'x':
        value = int(s[2:4], 16)
    elif s[2] == '{':
        value = int(s[3:-1], 16)
    else:
        value = int(s[2:6], 16)
    return chr(value)

