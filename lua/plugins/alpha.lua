return {
  "goolord/alpha-nvim",
  opts = function(_, opts) -- override the options using lazy.nvim
    opts.section.header.val = { -- change the header section value
      [[  =ccccc,      ,cccc       ccccc      ,cccc,  ?$$$$$$$,  ,ccc,   -ccc          ]],
      [[ :::"$$$$bc    $$$$$     ::`$$$$$c,  : $$$$$c`:"$$$$???'`."$$$$c,:`?$$c        ]],
      [[ `::::"?$$$$c,z$$$$F     `:: ?$$$$$c,`:`$$$$$h`:`?$$$,` :::`$$$$$$c,"$$h,      ]],
      [[   `::::."$$$$$$$$$'    ..,,,:"$$$$$$h, ?$$$$$$c`:"$$$$$$$b':"$$$$$$$$$$$c     ]],
      [[      `::::"?$$$$$$    :"$$$$c:`$$$$$$$$d$$$P$$$b`:`?$$$c : ::`?$$c "?$$$$h,   ]],
      [[        `:::.$$$$$$$c,`::`????":`?$$$E"?$$$$h ?$$$.`:?$$$h..,,,:"$$$,:."?$$$c  ]],
      [[          `: $$$$$$$$$c, ::``  :::"$$$b `"$$$ :"$$$b`:`?$$$$$$$c``?$F `:: "::  ]],
      [[           .,$$$$$"?$$$$$c,    `:::"$$$$.::"$.:: ?$$$.:.???????" `:::  ` ```   ]],
      [[           'J$$$$P'::"?$$$$h,   `:::`?$$$c`::``:: .:: : :::::''   `            ]],
      [[          :,$$$$$':::::`?$$$$$c,  ::: "::  ::  ` ::'   ``                      ]],
      [[         .'J$$$$F  `::::: .::::    ` :::'  `                                   ]],
      [[        .: ???):     `:: :::::                                                 ]],
      [[        : :::::'        `                                                      ]],
      [[         ``                                                                    ]],
    }
  end,
}
