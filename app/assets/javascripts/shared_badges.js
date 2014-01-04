
  if ($('#shared_badges_table').length) {
    if (!$('#current_user_badges').length) {
      $('#shared_badges_table').append('<tr><td>My badges<td id="current_user_badges"></td></tr>')
    } else {
     $('#current_user_badges').children().each( function (index, child) {
        $(child).attr('data-cid', index + 100)
        $($('.remove_badge')[index]).attr('data-cid', index + 100)
      })
    }

    var Badge = Backbone.Model.extend({
    })

    var BadgeList = Backbone.Collection.extend({
      model: Badge,
      remove_by_value: function (key, val) {
        if ( key === undefined || val === undefined) {
          return
        }
        this.forEach(function (model) {
          if (model.get(key) === val) {
            this.remove(model)
          }
        }, this)
      }
    })

    var AllBadgesView = Backbone.View.extend({
      el: $('.share_badge'),

      events: {
        'click .add_badge': 'add_badge',
        'click .remove_badge': 'remove_badge'
      },

      initialize: function () {
        this.shared_badges = window.shared_badges;
      },

      add_badge: function (e) {
        this.shared_badges.add_badge(e)
      },

      remove_badge: function (e) {
        this.shared_badges.remove_badge(e)
      }
    })

    var SharedBadgeView = Backbone.View.extend({
      el: $('#current_user_badges'),

      initialize: function () {
        this.collection = new BadgeList()
        this.collection.bind('add', this.append_badge)
        this.render()
      },

      render: function () {
      },

      add_badge: function (e) {
        var badge = new Badge()
        $(e.target).data('cid', badge.cid)
        var elem = $(e.target).parent()
        badge.set({
          name: elem.data('name'),
          url: elem.data('icon')
        })
        this.collection.add(badge)
      },

      append_badge: function (badge) {
        $('#current_user_badges').append('<img alt="' + badge.get('name') + '"src="' + badge.get('url') + '" width="40" data-cid="' + badge.cid + '"/>')
      },

      remove_badge: function (e) {
        this.collection.remove_by_value('name', $(e.target).parent().data('name'))
        $('#current_user_badges [data-cid="' + $(e.target).data('cid') + '"]').remove()
      }
    })

    window.shared_badges = new SharedBadgeView()
    window.all_badges = new AllBadgesView()
  }