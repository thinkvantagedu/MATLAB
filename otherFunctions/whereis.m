function whereis(str, flags)
% whereis(str, flags)
% Find and print all occurences of str in all .m files in the current directory.
% * flags: character array (string) with flags:
%   * 'r': str is treated as a (matlab) regular expression. This is 
%          automatically set if str contains '|' or '.*'.
%   * 'R': str is NOT a regular expression (turn of auto detection - 'r' will
%          still turn regexp on).
%   * 'n','d': sort matching files on name or date.
%   * 'i': ignore case.
%   * 'h','H': turn on or off highligh mode (default: try to determine).
% If str contains '.*' or '|', then it will be treated as a regular expression
%   (unless the 'R' flag is given).
% If str is treated as a regular expression, each line in each file is compared
%  to str using the regexp(line,str) or regexpi(line,str) function.
% If str is not treated as a regular expression, the lines are compared using
%  the strfind(line,str) function.
% By default, str = '% Status:|TODO:' (ignore-cased), so the empty function call
% >> whereis
% displays all files/lines that contains a status or todo comment.
% 
% Examples: examine usage of the function fprintf(...), and general status
% >> whereis fprintf(
% /--- whereis(fprintf()
% |    file    |    date    | row | matches
% | foobar.m   | 2014-01-27 |  69 | fprintf('Writing data to file %s ...', fn);
% |            |            | 112 |   fprintf(fptr, fstr, args{:});
% |            |            | 135 | fprintf(' Done!\n');
% | optimize.m | 2013-05-16 |  69 | fprintf('Problem has %d variables\n', M);
% |            |            | 835 | fprintf('Problem solved in %g seconds\n', toc(t));
% \---
% >> whereis
% /--- whereis()
% | Default search string: '% Status:|TODO:'
% |    file    |    date    | row | matches
% | foobar.m   | 2014-01-27 |  13 | % Status: Not done.
% |            |            | 110 |   % TODO: Solve this for the fieldwidth=0 case
% | optimize.m | 2013-05-16 |  19 | % Status: Seems to work.
% \---
% 
% Date: 2014-02-11
% Author: Petter Källström <petter.kallstrom@liu.se>
% Status: Seems to work.

  if nargin < 1, str = '% Status:|TODO:'; end
  if nargin < 2, flags = ''; end
  do_regexp = any(flags == 'r') || (~any(flags=='R') && ~isempty([strfind(str, '.*') strfind(str,'|')]));
  ignore_case = any(flags == 'i') || nargin<1;
  highlight = any(flags == 'h') || (~any(flags=='H') && usejava('desktop')); % highlight on or off
  % The highlight might not work on Windows/Mac
  
  if highlight
    hstart = '<strong>'; % Highlight-start tag.
    hstop = '</strong>'; % Highlight-stop tag.
  else
    hstart = ''; % No highlight-start tag.
    hstop = ''; % No highlight-stop tag.
  end
  files = dir('*.m');
  if any(flags=='n');
    [~,six] = sort({files(:).name});
    files = files(six);
  end
  if any(flags=='d');
    [~,six] = sort([files(:).datenum]);
    files = files(six);
  end
  if ignore_case && ~do_regexp
    str = lower(str); % found no strfindi, so lower str in once for all.
  end
  matchcounts = zeros(size(files));
  allmatches = cell(size(files)); % matching files will contain cell arrays with the matching lines.
  allrows = cell(size(files));    % matching files will contain vector with row numbers.
  matchinglines = zeros(1,10);
  matches = cell(1,10);
  for i=1:length(files)
    % to use importdata(fname, '\n') is convinient, but markedly slow.
    fp = fopen(files(i).name, 'r');
    matchingcount = 0;
    row = 0;
    while ~feof(fp)
      line = fgetl(fp);
      row = row + 1;
      if ignore_case
        if do_regexp
          foo = regexpi(line,str);
        else
          foo = strfind(lower(line),str);
        end
      else
        if do_regexp
          foo = regexp(line,str);
        else
          foo = strfind(line,str);
        end
      end
      if ~isempty(foo);
        if highlight
          if do_regexp
            line = regexprep(line, ['(' str ')'], [hstart '$1' hstop]);
          else
            for j=length(foo):-1:1
              line = [line(1:foo(j)-1) ...
                      hstart line(foo(j):foo(j)+length(str)-1) hstop ...
                      line(foo(j)+length(str):end)];
            end
          end
        end
        matchingcount = matchingcount + 1;
        matchinglines(matchingcount) = row;
        matches{matchingcount} = line;
      end
    end
    fclose(fp);
    matchcounts(i) = matchingcount;
    allmatches{i} = matches(1:matchingcount);
    allrows{i} = matchinglines(1:matchingcount);
  end
  
  keepix = matchcounts > 0;
  
  % Prepare printing:
  fnwidth = max(toall({files(keepix).name}, @length));
  rownowidth = 1+floor(log10(max(toall({files(keepix).name}, @max))));
  rownowidth = max(3, rownowidth);
  
  if nargin == 1
    fprintf('/--- whereis(''%s'')\n', str);
  elseif nargin > 1
    fprintf('/--- whereis(''%s'', ''%s'')\n', str, flags);
  else
    fprintf('/--- whereis()\n');
    fprintf('| Default search string: ''%s''\n', str);
  end
  fprintf('%s| %s |    date    | %s | matches%s\n', hstart, fill('file', fnwidth, 'c'), fill('row', rownowidth, 'r'), hstop);
  for i=1:length(files)
    if keepix(i)
      rows = allrows{i};
      matches = allmatches{i};
      ymd = datevec(files(i).datenum); ymd = ymd(1:3);
      fprintf('| %s | %04d-%02d-%02d | %s | %s\n', fill(files(i).name, fnwidth), ymd,  fill(rows(1), rownowidth, 'r'), matches{1});
      for j=2:length(matches)
        fprintf('| %s |            | %s | %s\n', fill('', fnwidth), fill(rows(j), rownowidth, 'r'), matches{j})
      end
    end
  end
  fprintf('\\---\n');
end

function res = toall(cellarray, fun)
  if isempty(cellarray)
    res = [];
    return;
  end
  res = fun(cellarray{1}); % gives a scalar with the correct type.
  res = res(ones(size(cellarray))); % resize to final size
  for i=2:numel(cellarray)
    res(i) = fun(cellarray{i});
  end
end

function res = fill(str, N, align)
  if nargin < 3, align = ''; end
  if ~ischar(str)
    str = sprintf('%g', str);
  end
  blank = ' ';
  M = N - length(str);
  if isempty(align) || align == 'l'
    res = [str blank(ones(1,M))]; 
  elseif align == 'r'
    res = [blank(ones(1,M)) str];
  elseif align == 'c'
    res = [blank(ones(1,round(M/2))) str blank(ones(1,M-round(M/2)))];
  else
    error('fill:invalid_align', 'Invalid align character in fill(str,N,align)');
  end
end

