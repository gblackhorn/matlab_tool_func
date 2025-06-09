function extract_logseq_blocks(tag)
    % extract_logseq_blocks - Extracts blocks under a given [[tag]] from Logseq journal files.
    % Opens a GUI to select the Logseq folder and writes the output to '<tag>_Export.md'.

    if nargin < 1
        error('Please specify a tag to search for, e.g., extract_logseq_blocks(''LabBook'')');
    end

    % Select Logseq root folder
    root_folder = uigetdir('', 'Select the Logseq root folder (containing "journals" folder)');
    if root_folder == 0
        disp('Folder selection cancelled.');
        return;
    end

    journal_folder = fullfile(root_folder, 'journals');
    if ~isfolder(journal_folder)
        error('The selected folder does not contain a "journals" subfolder.');
    end

    files = dir(fullfile(journal_folder, '*.md'));
    output_lines = {};
    tag_pattern = ['[[', tag, ']]'];

    for i = 1:length(files)
        file_path = fullfile(journal_folder, files(i).name);
        fid = fopen(file_path, 'r', 'n', 'UTF-8');
        if fid == -1
            warning('Could not open file: %s', files(i).name);
            continue;
        end

        raw_lines = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
        fclose(fid);
        raw_lines = raw_lines{1};

        date_str = strrep(files(i).name(1:end-3), '_', '-');

        for j = 1:length(raw_lines)
            line = raw_lines{j};
            if contains(strtrim(line), tag_pattern)
                parent_indent = get_indent(line);
                block_lines = {['# ', date_str]};

                % add the [[tag]] line itself
                block_lines{end+1} = line;

                for k = j+1:length(raw_lines)
                    child_indent = get_indent(raw_lines{k});
                    if child_indent > parent_indent
                        block_lines{end+1} = raw_lines{k};
                    else
                        break;
                    end
                end

                output_lines = [output_lines; block_lines(:); {''}];
            end
        end
    end

    % Write to output file
    output_path = fullfile(root_folder, [tag '_Export.md']);
    fid = fopen(output_path, 'w', 'n', 'UTF-8');
    if fid == -1
        error('Cannot open output file for writing.');
    end

    for i = 1:length(output_lines)
        fprintf(fid, '%s\n', output_lines{i});
    end
    fclose(fid);
    fprintf('Exported blocks to %s\n', output_path);
end

function indent = get_indent(line)
    indent = length(regexp(line, '^\s*', 'match', 'once'));
end
