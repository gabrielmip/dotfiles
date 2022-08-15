function! s:enterComparison()
  if expand('%:p') =~ '^fugitive:[\\/][\\/]'
    echoerr "Go to a versioned file first"
  else
    let g:revisionComparisonTriggerBuffer = bufnr('%')
    execute "0Gclog"
    execute "cfirst"
  endif
  call s:showRevision()
endfunction

function! s:assertComparisonRequisites()
  if !exists('g:revisionComparisonTriggerBuffer')
    call StartComparison()
  endif

  let attrs = getqflist({'title': 0})

  let title = get(attrs, 'title', '')
  if title !~ '.*Gclog'
    echoerr 'Remember to call StartComparison() first'
    return
  endif

  if expand('%:p') =~ '^fugitive:[\\/][\\/]'
    execute "b" . g:revisionComparisonTriggerBuffer
    try | silent execute "only" | catch | endtry
  endif
endfunction

function! s:showRevision()
  call s:assertComparisonRequisites()
  let attrs = getqflist({'idx': 0})
  let idx = get(attrs, 'idx', 0)
  let qflist = getqflist()

  if idx >= len(qflist)
    echo 'You reached the end of the revision list'
    return
  endif

  let olderRevision = split(qflist[idx]['module'], ':')[0]
  execute "cc" | execute "Gvdiffsplit " . olderRevision
endfunction

function! s:moveInHistory(next)
  call s:assertComparisonRequisites()
  if a:next
    silent execute "cn"
  else
    silent execute "cp"
  endif
  call s:showRevision()
endfunction

function! s:quitComparison()
  if exists('g:revisionComparisonTriggerBuffer')
    execute "b" . g:revisionComparisonTriggerBuffer
    try | execute "only" | catch | endtry
    execute "unlet g:revisionComparisonTriggerBuffer"
  else
    echo "You have not run a comparison revision yet"
  endif
endfunction

function! ToggleRevisionComparison()
  if exists('g:revisionComparisonTriggerBuffer')
    call s:quitComparison()
  else
    call s:enterComparison()
  endif
endfunction

function! NewerRevision()
  call s:moveInHistory(0)
endfunction

function! OlderRevision()
  call s:moveInHistory(1)
endfunction

function! ShowRevision()
  call s:showRevision()
endfunction
