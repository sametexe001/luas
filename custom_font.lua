local Fonts; do 
    local HttpService = cloneref(game:GetService("HttpService"));
    Fonts = {
        Folder = "CustomFonts",

        ["windows-xp-tahoma"] = {
            FileName = {"windowsXPTahoma.ttf", "windowsXPTahoma.json"},
            Url = "https://raw.githubusercontent.com/sametexe001/luas/main/fonts/windows-xp-tahoma.ttf"
        };

        ["proggy-square"] = {
            FileName = {"proggySquare.ttf", "proggySquare.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/proggy-square.ttf"
        };

        ["proggy-clean"] = {
            FileName = {"proggyClean.ttf", "proggySquare.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/proggy-clean.ttf"
        };

        ["proggy-tiny"] = {
            FileName = {"proggyTiny.ttf", "proggyTiny.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/proggy-tiny.ttf"
        };

        ["minecraftia"] = {
            FileName = {"minecraftia.ttf", "minecraftia.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/minecraftia.ttf"
        };

        ["verdana"] = {
            FileName = {"verdana.ttf", "verdana.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/verdana.ttf"
        };

        ["cozette-vector"] = {
            FileName = {"cozetteVector.ttf", "cozetteVector.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/cozette-vector.ttf"
        };

        ["teachers-pet"] = {
            FileName = {"teachersPet.ttf", "teachersPet.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/teachers-pet.ttf"
        };

        ["open-sans-px"] = {
            FileName = {"openSansPX.ttf", "openSansPX.json"},
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/open-sans-px.ttf"
        };
    };

    if not isfolder(Fonts.Folder) then
        makefolder(Fonts.Folder);
    end;

    for Name, FontData in Fonts do
        if type(FontData) == "table" then
            local FileName = FontData.FileName;
            
            if not isfile(Fonts.Folder .. "/" .. FileName[1]) then
                writefile(Fonts.Folder .. "/" .. FileName[1], game:HttpGet(FontData.Url));
            end;

            local Data = {
                Name = Name;
                Faces = {{
                    Name = "Regular";
                    Weight = 200;
                    Style = "Regular";
                    AssetId = getcustomasset(Fonts.Folder .. "/" .. FileName[1]);
                }};
            };

            if not isfile(Fonts.Folder .. "/" .. FileName[2]) then
                writefile(Fonts.Folder .. "/" .. FileName[2], HttpService:JSONEncode(Data));
            end;
        end;
    end;

    function Fonts.GetFont(Name)
        for FontName, FontData in Fonts do
            if FontName == Name then 
                return Font.new(getcustomasset(Fonts.Folder .. "/" .. FontData.FileName[2]));
            end;
        end;
    end;
end;

return Fonts;
