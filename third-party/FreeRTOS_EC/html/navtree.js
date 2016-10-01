var NAVTREE =
[
  [ "FreeRTOS Extension Class", "index.html", [
    [ "Modules", "modules.html", [
      [ "FreeRTOS Class Extension", "group___free_r_t_o_s___c_p_p___e_x_t.html", [
        [ "FreeRTOS Managed Class Extension", "group___free_r_t_o_s___managed.html", null ],
        [ "FreeRTOS Wrapper Class", "group___free_r_t_o_s___wrapper.html", null ]
      ] ]
    ] ],
    [ "Class List", "annotated.html", [
      [ "AManagedTask", "class_a_managed_task.html", null ],
      [ "ASyncObject", "class_a_sync_object.html", null ],
      [ "ATimer", "class_a_timer.html", null ],
      [ "CBinarySemaphore", "class_c_binary_semaphore.html", null ],
      [ "CCountingSemaphore", "class_c_counting_semaphore.html", null ],
      [ "CFreeRTOS", "class_c_free_r_t_o_s.html", null ],
      [ "CMessage", "class_c_message.html", null ],
      [ "CMessageTask", "class_c_message_task.html", null ],
      [ "CMutex", "class_c_mutex.html", null ],
      [ "CQueue", "class_c_queue.html", null ],
      [ "CRecursiveMutex", "class_c_recursive_mutex.html", null ],
      [ "CSharedResource< T, L, nTimeout >", "class_c_shared_resource.html", null ],
      [ "CTask", "class_c_task.html", null ],
      [ "IFreeRTOSObj", "class_i_free_r_t_o_s_obj.html", null ],
      [ "IMessageTaskDelegate", "class_i_message_task_delegate.html", null ]
    ] ],
    [ "Class Index", "classes.html", null ],
    [ "Class Hierarchy", "hierarchy.html", [
      [ "CFreeRTOS", "class_c_free_r_t_o_s.html", null ],
      [ "CMessage", "class_c_message.html", null ],
      [ "CSharedResource< T, L, nTimeout >", "class_c_shared_resource.html", null ],
      [ "IFreeRTOSObj", "class_i_free_r_t_o_s_obj.html", [
        [ "ASyncObject", "class_a_sync_object.html", [
          [ "CBinarySemaphore", "class_c_binary_semaphore.html", null ],
          [ "CCountingSemaphore", "class_c_counting_semaphore.html", null ],
          [ "CMutex", "class_c_mutex.html", null ],
          [ "CRecursiveMutex", "class_c_recursive_mutex.html", null ]
        ] ],
        [ "ATimer", "class_a_timer.html", null ],
        [ "CQueue", "class_c_queue.html", null ],
        [ "CTask", "class_c_task.html", [
          [ "AManagedTask", "class_a_managed_task.html", [
            [ "CMessageTask", "class_c_message_task.html", null ]
          ] ]
        ] ]
      ] ],
      [ "IMessageTaskDelegate", "class_i_message_task_delegate.html", null ]
    ] ],
    [ "Class Members", "functions.html", null ],
    [ "File List", "files.html", [
      [ "AManagedTask.cpp", null, null ],
      [ "AManagedTask.h", "_a_managed_task_8h.html", null ],
      [ "ASyncObject.cpp", null, null ],
      [ "ASyncObject.h", "_a_sync_object_8h.html", null ],
      [ "ATimer.cpp", null, null ],
      [ "ATimer.h", "_a_timer_8h.html", null ],
      [ "CBinarySemaphore.cpp", null, null ],
      [ "CBinarySemaphore.h", "_c_binary_semaphore_8h.html", null ],
      [ "CCountingSemaphore.cpp", null, null ],
      [ "CCountingSemaphore.h", "_c_counting_semaphore_8h.html", null ],
      [ "CFreeRTOS.cpp", null, null ],
      [ "CFreeRTOS.h", "_c_free_r_t_o_s_8h.html", null ],
      [ "CMessageTask.cpp", null, null ],
      [ "CMessageTask.h", "_c_message_task_8h.html", null ],
      [ "CMutex.cpp", null, null ],
      [ "CMutex.h", "_c_mutex_8h.html", null ],
      [ "CQueue.cpp", null, null ],
      [ "CQueue.h", "_c_queue_8h.html", null ],
      [ "CRecursiveMutex.cpp", null, null ],
      [ "CRecursiveMutex.h", "_c_recursive_mutex_8h.html", null ],
      [ "CSharedResource.h", "_c_shared_resource_8h.html", null ],
      [ "CTask.cpp", null, null ],
      [ "CTask.h", "_c_task_8h.html", null ],
      [ "IFreeRTOSProtocol.h", "_i_free_r_t_o_s_protocol_8h.html", null ],
      [ "IMessageTaskDelegate.h", "_i_message_task_delegate_8h.html", null ],
      [ "Message.h", "_message_8h.html", null ],
      [ "MessageMacro.h", "_message_macro_8h.html", null ]
    ] ],
    [ "File Members", "globals.html", null ]
  ] ]
];

function createIndent(o,domNode,node,level)
{
  if (node.parentNode && node.parentNode.parentNode)
  {
    createIndent(o,domNode,node.parentNode,level+1);
  }
  var imgNode = document.createElement("img");
  if (level==0 && node.childrenData)
  {
    node.plus_img = imgNode;
    node.expandToggle = document.createElement("a");
    node.expandToggle.href = "javascript:void(0)";
    node.expandToggle.onclick = function() 
    {
      if (node.expanded) 
      {
        $(node.getChildrenUL()).slideUp("fast");
        if (node.isLast)
        {
          node.plus_img.src = node.relpath+"ftv2plastnode.png";
        }
        else
        {
          node.plus_img.src = node.relpath+"ftv2pnode.png";
        }
        node.expanded = false;
      } 
      else 
      {
        expandNode(o, node, false);
      }
    }
    node.expandToggle.appendChild(imgNode);
    domNode.appendChild(node.expandToggle);
  }
  else
  {
    domNode.appendChild(imgNode);
  }
  if (level==0)
  {
    if (node.isLast)
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2plastnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2lastnode.png";
        domNode.appendChild(imgNode);
      }
    }
    else
    {
      if (node.childrenData)
      {
        imgNode.src = node.relpath+"ftv2pnode.png";
      }
      else
      {
        imgNode.src = node.relpath+"ftv2node.png";
        domNode.appendChild(imgNode);
      }
    }
  }
  else
  {
    if (node.isLast)
    {
      imgNode.src = node.relpath+"ftv2blank.png";
    }
    else
    {
      imgNode.src = node.relpath+"ftv2vertline.png";
    }
  }
  imgNode.border = "0";
}

function newNode(o, po, text, link, childrenData, lastNode)
{
  var node = new Object();
  node.children = Array();
  node.childrenData = childrenData;
  node.depth = po.depth + 1;
  node.relpath = po.relpath;
  node.isLast = lastNode;

  node.li = document.createElement("li");
  po.getChildrenUL().appendChild(node.li);
  node.parentNode = po;

  node.itemDiv = document.createElement("div");
  node.itemDiv.className = "item";

  node.labelSpan = document.createElement("span");
  node.labelSpan.className = "label";

  createIndent(o,node.itemDiv,node,0);
  node.itemDiv.appendChild(node.labelSpan);
  node.li.appendChild(node.itemDiv);

  var a = document.createElement("a");
  node.labelSpan.appendChild(a);
  node.label = document.createTextNode(text);
  a.appendChild(node.label);
  if (link) 
  {
    a.href = node.relpath+link;
  } 
  else 
  {
    if (childrenData != null) 
    {
      a.className = "nolink";
      a.href = "javascript:void(0)";
      a.onclick = node.expandToggle.onclick;
      node.expanded = false;
    }
  }

  node.childrenUL = null;
  node.getChildrenUL = function() 
  {
    if (!node.childrenUL) 
    {
      node.childrenUL = document.createElement("ul");
      node.childrenUL.className = "children_ul";
      node.childrenUL.style.display = "none";
      node.li.appendChild(node.childrenUL);
    }
    return node.childrenUL;
  };

  return node;
}

function showRoot()
{
  var headerHeight = $("#top").height();
  var footerHeight = $("#nav-path").height();
  var windowHeight = $(window).height() - headerHeight - footerHeight;
  navtree.scrollTo('#selected',0,{offset:-windowHeight/2});
}

function expandNode(o, node, imm)
{
  if (node.childrenData && !node.expanded) 
  {
    if (!node.childrenVisited) 
    {
      getNode(o, node);
    }
    if (imm)
    {
      $(node.getChildrenUL()).show();
    } 
    else 
    {
      $(node.getChildrenUL()).slideDown("fast",showRoot);
    }
    if (node.isLast)
    {
      node.plus_img.src = node.relpath+"ftv2mlastnode.png";
    }
    else
    {
      node.plus_img.src = node.relpath+"ftv2mnode.png";
    }
    node.expanded = true;
  }
}

function getNode(o, po)
{
  po.childrenVisited = true;
  var l = po.childrenData.length-1;
  for (var i in po.childrenData) 
  {
    var nodeData = po.childrenData[i];
    po.children[i] = newNode(o, po, nodeData[0], nodeData[1], nodeData[2],
        i==l);
  }
}

function findNavTreePage(url, data)
{
  var nodes = data;
  var result = null;
  for (var i in nodes) 
  {
    var d = nodes[i];
    if (d[1] == url) 
    {
      return new Array(i);
    }
    else if (d[2] != null) // array of children
    {
      result = findNavTreePage(url, d[2]);
      if (result != null) 
      {
        return (new Array(i).concat(result));
      }
    }
  }
  return null;
}

function initNavTree(toroot,relpath)
{
  var o = new Object();
  o.toroot = toroot;
  o.node = new Object();
  o.node.li = document.getElementById("nav-tree-contents");
  o.node.childrenData = NAVTREE;
  o.node.children = new Array();
  o.node.childrenUL = document.createElement("ul");
  o.node.getChildrenUL = function() { return o.node.childrenUL; };
  o.node.li.appendChild(o.node.childrenUL);
  o.node.depth = 0;
  o.node.relpath = relpath;

  getNode(o, o.node);

  o.breadcrumbs = findNavTreePage(toroot, NAVTREE);
  if (o.breadcrumbs == null)
  {
    o.breadcrumbs = findNavTreePage("index.html",NAVTREE);
  }
  if (o.breadcrumbs != null && o.breadcrumbs.length>0)
  {
    var p = o.node;
    for (var i in o.breadcrumbs) 
    {
      var j = o.breadcrumbs[i];
      p = p.children[j];
      expandNode(o,p,true);
    }
    p.itemDiv.className = p.itemDiv.className + " selected";
    p.itemDiv.id = "selected";
    $(window).load(showRoot);
  }
}

