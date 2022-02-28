package gitops.only_image_change

# This package checks if:
#       Only files in some certain prefixes are changed
#   and only "image" are modified in these changed files
# On success, violations[_] is empty set, otherwise error messages will be given

# check whether data.input.path starts with some certain prefix

import data.input
import future.keywords.in

prefixes := split(opa.runtime().env.PREFIXES, ":")

default matched = false

matched {
	some p in prefixes
	startswith(data.input.path, p)
}

violations[{"msg": msg}] {
	not matched == true
	msg := sprintf("path %s not in any of the prefixes %s", [data.input.path, prefixes])
}

# verify two yaml files (data.input.newfile, data.input.oldfile) only different on "*.\.image"

kompare[pv] {
	[p, v] := walk(input.newfile)
	not is_array(v)
	not is_set(v)
	not is_object(v)
	not walk(input.oldfile, [p, v])
	pv = [p, v]
}

kompare[pv] {
	[p, v] := walk(input.oldfile)
	not is_array(v)
	not is_set(v)
	not is_object(v)
	not walk(input.newfile, [p, v])
	pv = [p, v]
}

onlyimage[pv] {
	[p, v] := kompare[pv]
	p[minus(count(p), 1)] == "image"
	pv = [p, v]
}

violations[{"msg": msg}] {
	not count(onlyimage) == count(kompare)
	msg := sprintf("Leaves other than image are changed, Changes found: %d, image changed: %d", [count(kompare), count(onlyimage)])
}

violations[{"msg": msg}] {
	not count(kompare) > 0
	msg := sprintf("No changes found or changed files are not yaml nor json)", [])
}
