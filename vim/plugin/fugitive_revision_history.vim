function! s:enterComparison()
  if expand('%:p') =~ '^fugitive:[\\/][\\/]'
    echoerr "Go to a versioned file first"
  else
    let g:revisionHistoryBuffer = bufnr('%')
    let g:revisionHistoryState = 'working_diff'
    execute "0Gclog"
    execute "cfirst"
    call s:showRevision()
  endif
endfunction

function! s:assertComparisonRequisites()
  if expand('%:p') =~ '^fugitive:[\\/][\\/]'
    execute "b" . g:revisionHistoryBuffer
    try | silent execute "only" | catch | endtry
  endif
endfunction

function! s:showRevision()
  call s:assertComparisonRequisites()
  let attrs = getqflist({'idx': 0})
  let idx = get(attrs, 'idx', 0)
  let qflist = getqflist()
  let g:revisionHistoryLen = len(qflist)
  let g:revisionHistoryIdx = idx
  
  if g:revisionHistoryState =~ 'working_diff'
    echo "Working index diff"
    execute "silent Gvdiffsplit"
    return
  endif

  echo "(" . (idx - 1) . " out of " . len(qflist). "): " . qflist[idx - 2]['text']
  let olderRevision = split(qflist[idx - 2]['module'], ':')[0]
  execute "silent cc" | execute "silent Gvdiffsplit " . olderRevision
endfunction

function! s:moveInHistory(next)
  if a:next
    if g:revisionHistoryState =~ 'history' && g:revisionHistoryIdx >= g:revisionHistoryLen
      echo 'You reached the end of the revision list'
    else
      let g:revisionHistoryState = 'history'
      execute "silent cn"
      call s:showRevision()
    endif
  else
    if g:revisionHistoryState =~ 'working_diff'
      echo 'You reached the beginning of the revision list'
      return
    else
      if g:revisionHistoryIdx <= 2
        let g:revisionHistoryState = 'working_diff'
      endif
      execute "silent cp"
      call s:showRevision()
    endif
  endif
endfunction

function! s:quitComparison()
  if exists('g:revisionHistoryBuffer')
    execute "b" . g:revisionHistoryBuffer
    try | execute "only" | catch | endtry
    execute "unlet g:revisionHistoryBuffer"
    execute "unlet g:revisionHistoryIdx"
    execute "unlet g:revisionHistoryLen"
    execute "unlet g:revisionHistoryState"
  else
    echo "You have not run a comparison revision yet"
  endif
endfunction

function! ToggleRevisionComparison()
  if exists('g:revisionHistoryBuffer')
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
