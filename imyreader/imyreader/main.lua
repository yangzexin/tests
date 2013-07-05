require "UIViewController"

function main(args)
    local vc = UIViewController:create("imyreader"):retain();
    function vc:viewDidPop()
        super:viewDidPop();
        vc:release();
    end
    function vc:viewDidLoad()
        super:viewDidLoad();
        print("lua scripts loaded");
    end
    vc:pushToRelatedViewController();
end